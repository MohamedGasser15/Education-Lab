using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Auth;
using EduLab_Shared.DTOs.Instructor;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    public class InstructorService : IInstructorService
    {
        private readonly UserManager<ApplicationUser> _userManager;

        public InstructorService(UserManager<ApplicationUser> userManager)
        {
            _userManager = userManager;
        }

        public async Task<InstructorListDTO> GetAllInstructorsAsync()
        {
            var instructors = await _userManager.Users
                .Include(u => u.CoursesCreated)
                .ToListAsync();

            var instructorList = new List<ApplicationUser>();

            foreach (var user in instructors)
            {
                var roles = await _userManager.GetRolesAsync(user);
                if (roles.Contains(SD.Instructor))
                {
                    user.Role = string.Join(", ", roles);
                    instructorList.Add(user);
                }
            }

            var instructorDTOs = instructorList.Select(instructor => new InstructorDTO
            {
                Id = instructor.Id,
                FullName = instructor.FullName,
                Title = instructor.Title,
                ProfileImageUrl = instructor.ProfileImageUrl ?? "https://randomuser.me/api/portraits/men/32.jpg",
                Rating = 4.7, // TODO: بعدين هتجيبه من Reviews table
                TotalStudents = 1200, // TODO: يجي من Enrollments
                TotalCourses = instructor.CoursesCreated?.Count ?? 0,
                Location = instructor.Location,
                About = instructor.About,
                InstructorSubjects = instructor.Subjects,
                GitHubUrl = instructor.GitHubUrl,
                LinkedInUrl = instructor.LinkedInUrl,
                TwitterUrl = instructor.TwitterUrl,
                FacebookUrl = instructor.FacebookUrl
            }).ToList();

            return new InstructorListDTO
            {
                Instructors = instructorDTOs,
                TotalCount = instructorDTOs.Count
            };
        }

        public async Task<InstructorDTO?> GetInstructorByIdAsync(string id)
        {
            var instructor = await _userManager.Users
                .Include(u => u.CoursesCreated)
                .FirstOrDefaultAsync(u => u.Id == id);

            if (instructor == null)
                return null;

            var roles = await _userManager.GetRolesAsync(instructor);
            if (!roles.Contains(SD.Instructor))
                return null;

            return new InstructorDTO
            {
                Id = instructor.Id,
                FullName = instructor.FullName,
                Title = instructor.Title,
                ProfileImageUrl = instructor.ProfileImageUrl ?? "https://randomuser.me/api/portraits/men/32.jpg",
                Rating = 4.7,
                TotalStudents = 1200,
                TotalCourses = instructor.CoursesCreated?.Count ?? 0,
                Location = instructor.Location,
                About = instructor.About,
                InstructorSubjects = instructor.Subjects,
                GitHubUrl = instructor.GitHubUrl,
                LinkedInUrl = instructor.LinkedInUrl,
                TwitterUrl = instructor.TwitterUrl,
                FacebookUrl = instructor.FacebookUrl
            };
        }


        public async Task<List<InstructorDTO>> GetTopRatedInstructorsAsync(int count)
        {
            var users = _userManager.Users.ToList();
            var instructors = new List<ApplicationUser>();

            foreach (var user in users)
            {
                var roles = await _userManager.GetRolesAsync(user);

                if (roles.Contains(SD.Instructor))
                {
                    user.Role = string.Join(", ", roles);
                    instructors.Add(user);
                }
            }

            return instructors.Take(count)
                .Select(instructor => new InstructorDTO
                {
                    Id = instructor.Id,
                    FullName = instructor.FullName,
                    Title = instructor.Title,
                    ProfileImageUrl = instructor.ProfileImageUrl ?? "https://randomuser.me/api/portraits/men/32.jpg",
                    Rating = 4.7, 
                    TotalStudents = 1200,
                    TotalCourses = 5, 
                    Location = instructor.Location,
                    About = instructor.About,
                    InstructorSubjects = instructor.Subjects,
                    GitHubUrl = instructor.GitHubUrl,
                    LinkedInUrl = instructor.LinkedInUrl,
                    TwitterUrl = instructor.TwitterUrl,
                    FacebookUrl = instructor.FacebookUrl
                }).ToList();
        }
    }
}
