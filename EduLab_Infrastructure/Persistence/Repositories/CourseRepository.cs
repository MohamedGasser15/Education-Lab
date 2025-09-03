using AutoMapper;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Infrastructure.DB;
using EduLab_Shared.DTOs.Course;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Infrastructure.Persistence.Repositories
{
    public class CourseRepository : Repository<Course>, ICourseRepository
    {
        private readonly ApplicationDbContext _db;
        private readonly IMapper _mapper;
        private readonly ILogger<CourseRepository> _logger;

        public CourseRepository(ApplicationDbContext db, IMapper mapper, ILogger<CourseRepository> logger) : base(db, logger)
        {
            _db = db;
            _mapper = mapper;
            _logger = logger;
        }

        public async Task<Course> AddAsync(Course course)
        {
            course.CreatedAt = DateTime.UtcNow;

            // Log to check ThumbnailUrl
            Console.WriteLine($"CourseRepository: ThumbnailUrl before saving = {course.ThumbnailUrl}");

            if (course.Sections != null)
            {
                foreach (var section in course.Sections)
                {
                    section.Course = course;
                    if (section.Lectures != null)
                    {
                        foreach (var lecture in section.Lectures)
                        {
                            lecture.Section = section;
                        }
                    }
                }
            }

            await _db.Courses.AddAsync(course);
            await _db.SaveChangesAsync();

            // Log after saving
            Console.WriteLine($"CourseRepository: ThumbnailUrl after saving = {course.ThumbnailUrl}");

            return course;
        }

        public async Task<Course> UpdateAsync(Course course)
        {
            var existingCourse = await _db.Courses
                .Include(c => c.Sections)
                .ThenInclude(s => s.Lectures)
                .FirstOrDefaultAsync(c => c.Id == course.Id);

            if (existingCourse == null)
            {
                return null;
            }

            // Update course properties
            _db.Entry(existingCourse).CurrentValues.SetValues(course);

            // Handle Sections
            var existingSectionIds = existingCourse.Sections.Select(s => s.Id).ToList();
            var newSectionIds = course.Sections?.Where(s => s.Id > 0).Select(s => s.Id).ToList() ?? new List<int>();
            var sectionsToRemove = existingCourse.Sections.Where(s => s.Id > 0 && !newSectionIds.Contains(s.Id)).ToList();
            foreach (var section in sectionsToRemove)
            {
                _db.Sections.Remove(section);
            }

            if (course.Sections != null)
            {
                foreach (var section in course.Sections)
                {
                    var existingSection = existingCourse.Sections.FirstOrDefault(s => s.Id == section.Id);
                    if (existingSection != null)
                    {
                        // Update existing section
                        _db.Entry(existingSection).CurrentValues.SetValues(section);
                        // Handle Lectures for existing section
                        var existingLectureIds = existingSection.Lectures?.Select(l => l.Id).ToList() ?? new List<int>();
                        var newLectureIds = section.Lectures?.Where(l => l.Id > 0).Select(l => l.Id).ToList() ?? new List<int>();
                        var lecturesToRemove = existingSection.Lectures?.Where(l => l.Id > 0 && !newLectureIds.Contains(l.Id)).ToList() ?? new List<Lecture>();
                        foreach (var lecture in lecturesToRemove)
                        {
                            _db.Lectures.Remove(lecture);
                        }

                        if (section.Lectures != null)
                        {
                            foreach (var lecture in section.Lectures)
                            {
                                var existingLecture = existingSection.Lectures?.FirstOrDefault(l => l.Id == lecture.Id);
                                if (existingLecture != null)
                                {
                                    // Update existing lecture
                                    _db.Entry(existingLecture).CurrentValues.SetValues(lecture);
                                }
                                else
                                {
                                    // Add new lecture
                                    lecture.SectionId = existingSection.Id;
                                    existingSection.Lectures.Add(lecture);
                                }
                            }
                        }
                    }
                    else
                    {
                        // Add new section
                        section.CourseId = course.Id;
                        section.Lectures = section.Lectures ?? new List<Lecture>();
                        var newLectures = section.Lectures.ToList(); // Copy lectures
                        section.Lectures.Clear(); // Clear to avoid saving lectures before section
                        existingCourse.Sections.Add(section);

                        // Save changes to assign Section.Id
                        await _db.SaveChangesAsync();

                        // Add lectures after section is saved
                        foreach (var lecture in newLectures)
                        {
                            lecture.SectionId = section.Id; // Use the new Section.Id
                            section.Lectures.Add(lecture);
                        }
                    }
                }
            }

            await _db.SaveChangesAsync();
            return existingCourse;
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var course = await _db.Courses
                .Include(c => c.Sections)
                .ThenInclude(s => s.Lectures)
                .FirstOrDefaultAsync(c => c.Id == id);

            if (course == null)
            {
                return false;
            }

            _db.Courses.Remove(course);
            await _db.SaveChangesAsync();
            return true;
        }

        public async Task<IEnumerable<Course>> GetCoursesByInstructorAsync(string instructorId)
        {
            return await _db.Courses
                .Include(c => c.Category)
                .Include(c => c.Sections)
                .ThenInclude(s => s.Lectures)
                .Where(c => c.InstructorId == instructorId)
                .ToListAsync();
        }
        public async Task<IEnumerable<Course>> GetApprovedCoursesByInstructorAsync(string instructorId, int count)
        {
            return await _db.Courses
                .Include(c => c.Category)
                .Include(c => c.Instructor)
                .Include(c => c.Sections)
                    .ThenInclude(s => s.Lectures)
                .Where(c => c.InstructorId == instructorId && c.Status == Coursestatus.Approved)
                .OrderByDescending(c => c.CreatedAt)
                .Take(count)
                .ToListAsync();
        }

        public async Task<IEnumerable<Course>> GetCoursesWithCategoryAsync(int categoryId)
        {
            return await _db.Courses
                .Include(c => c.Category)
                .Include(c => c.Instructor)
                .Include(c => c.Sections)
                    .ThenInclude(s => s.Lectures)
                .Where(c => c.CategoryId == categoryId)
                .ToListAsync();
        }


        public async Task<Course> GetCourseByIdAsync(int id, bool isTracking = false)
        {
            IQueryable<Course> query = isTracking ? _db.Courses : _db.Courses.AsNoTracking();
            return await query
                .Include(c => c.Category)
                .Include(c => c.Instructor)
                .Include(c => c.Sections)
                .ThenInclude(s => s.Lectures)
                .FirstOrDefaultAsync(c => c.Id == id);
        }

        public async Task<bool> BulkDeleteAsync(List<int> ids)
        {
            var courses = await _db.Courses
                .Where(c => ids.Contains(c.Id))
                .ToListAsync();

            if (!courses.Any())
            {
                return false;
            }

            _db.Courses.RemoveRange(courses);
            await _db.SaveChangesAsync();
            return true;
        }

        public async Task<bool> BulkUpdateStatusAsync(List<int> ids, Coursestatus status)
        {
            var courses = await _db.Courses
                .Where(c => ids.Contains(c.Id))
                .ToListAsync();

            if (!courses.Any())
            {
                return false;
            }

            foreach (var course in courses)
            {
                course.Status = status; 
            }

            await _db.SaveChangesAsync();
            return true;
        }

        public async Task<bool> UpdateStatusAsync(int courseId, Coursestatus status)
        {
            var course = await _db.Courses.FindAsync(courseId);
            if (course == null) return false;

            course.Status = status;
            await _db.SaveChangesAsync();
            return true;
        }
        // في CourseRepository
        public async Task<IEnumerable<Course>> GetApprovedCoursesByCategoriesAsync(List<int> categoryIds, int countPerCategory)
        {
            var result = new List<Course>();

            foreach (var categoryId in categoryIds)
            {
                var courses = await _db.Courses
                    .Include(c => c.Category)
                    .Include(c => c.Instructor)
                    .Include(c => c.Sections)
                    .ThenInclude(s => s.Lectures)
                    .Where(c => c.CategoryId == categoryId && c.Status == Coursestatus.Approved)
                    .OrderByDescending(c => c.CreatedAt)
                    .Take(countPerCategory)
                    .ToListAsync();

                result.AddRange(courses);
            }

            return result;
        }

        public async Task<IEnumerable<Course>> GetApprovedCoursesByCategoryAsync(int categoryId, int count)
        {
            return await _db.Courses
                .Include(c => c.Category)
                .Include(c => c.Instructor)
                .Include(c => c.Sections)
                .ThenInclude(s => s.Lectures)
                .Where(c => c.CategoryId == categoryId && c.Status == Coursestatus.Approved)
                .OrderByDescending(c => c.CreatedAt)
                .Take(count)
                .ToListAsync();
        }
    }
}
