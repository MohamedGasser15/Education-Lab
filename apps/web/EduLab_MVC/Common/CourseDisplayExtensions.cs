using EduLab_MVC.Models.DTOs.Course;
using System.Collections.Generic;
using System.Linq;

namespace EduLab_MVC.Common
{
    /// <summary>
    /// Extension methods for sorting and displaying courses according to learner status
    /// </summary>
    public static class CourseDisplayExtensions
    {
        /// <summary>
        /// Reorders courses so that un-enrolled courses appear first, and within each partition
        /// (unenrolled vs enrolled), courses are interleaved across instructors (round-robin)
        /// so that no single instructor monopolizes the top results.
        /// </summary>
        /// <param name="courses">The collection of courses to reorder</param>
        /// <param name="enrolledCourseIds">Set of course IDs the user is currently enrolled in</param>
        /// <returns>A new list of courses with un-enrolled courses first and instructor diversity</returns>
        public static List<CourseDTO> PrioritizeUnenrolled(
            this IEnumerable<CourseDTO>? courses,
            ISet<int>? enrolledCourseIds)
        {
            return DiversifyByInstructor(courses, enrolledCourseIds);
        }

        /// <summary>
        /// Reorders courses to ensure instructor diversity across the list using round-robin interleaving,
        /// while keeping un-enrolled courses prioritized if enrolledCourseIds is provided.
        /// Prevents courses from the same instructor from appearing consecutively or dominating a category.
        /// </summary>
        public static List<CourseDTO> DiversifyByInstructor(
            this IEnumerable<CourseDTO>? courses,
            ISet<int>? enrolledCourseIds = null)
        {
            if (courses == null) return new List<CourseDTO>();

            var list = courses as List<CourseDTO> ?? courses.ToList();
            if (list.Count <= 2)
            {
                return enrolledCourseIds != null && enrolledCourseIds.Count > 0
                    ? list.OrderBy(c => enrolledCourseIds.Contains(c.Id) ? 1 : 0).ToList()
                    : list;
            }

            if (enrolledCourseIds != null && enrolledCourseIds.Count > 0)
            {
                var unenrolled = list.Where(c => !enrolledCourseIds.Contains(c.Id)).ToList();
                var enrolled = list.Where(c => enrolledCourseIds.Contains(c.Id)).ToList();

                var diversifiedUnenrolled = InterleaveCoursesByInstructor(unenrolled);
                var diversifiedEnrolled = InterleaveCoursesByInstructor(enrolled);

                return diversifiedUnenrolled.Concat(diversifiedEnrolled).ToList();
            }

            return InterleaveCoursesByInstructor(list);
        }

        private static List<CourseDTO> InterleaveCoursesByInstructor(List<CourseDTO> list)
        {
            if (list.Count <= 2) return list;

            // Group by Instructor Identifier (InstructorId or InstructorName) preserving first appearance order
            var groups = list
                .GroupBy(c => !string.IsNullOrWhiteSpace(c.InstructorId)
                    ? c.InstructorId.Trim()
                    : (!string.IsNullOrWhiteSpace(c.InstructorName) ? c.InstructorName.Trim() : c.Id.ToString()),
                    StringComparer.OrdinalIgnoreCase)
                .Select(g => g.ToList())
                .ToList();

            if (groups.Count <= 1) return list;

            var result = new List<CourseDTO>(list.Count);
            int maxCount = groups.Max(g => g.Count);

            for (int round = 0; round < maxCount; round++)
            {
                foreach (var group in groups)
                {
                    if (round < group.Count)
                    {
                        result.Add(group[round]);
                    }
                }
            }

            return result;
        }
    }
}
