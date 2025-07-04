﻿using EduLab_Shared.DTOs.Course;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface ICourseService
    {
        Task<IEnumerable<CourseDTO>> GetAllCoursesAsync();
        Task<CourseDTO> GetCourseByIdAsync(int id);
        Task<CourseDTO> AddCourseAsync(CourseCreateDTO course);
        Task<CourseDTO> UpdateCourseAsync(CourseUpdateDTO course);
        Task<bool> DeleteCourseAsync(int id);
        Task<IEnumerable<CourseDTO>> GetCoursesByInstructorAsync(string instructorId);
        Task<IEnumerable<CourseDTO>> GetCoursesWithCategoryAsync(int categoryId);
    }
}
