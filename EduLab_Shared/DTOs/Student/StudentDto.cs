// EduLab_Shared/DTOs/Student/StudentDto.cs
using System;
using System.Collections.Generic;

namespace EduLab_Shared.DTOs.Student
{
    public class StudentDto
    {
        public string Id { get; set; }
        public string FullName { get; set; }
        public string Email { get; set; }
        public string PhoneNumber { get; set; }
        public string ProfileImageUrl { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? LastLogin { get; set; }
        public bool IsActive { get; set; }
    }

    public class StudentEnrollmentDto
    {
        public int EnrollmentId { get; set; }
        public int CourseId { get; set; }
        public string CourseTitle { get; set; }
        public string CourseThumbnailUrl { get; set; }
        public DateTime EnrolledAt { get; set; }
        public decimal ProgressPercentage { get; set; }
        public int CompletedLectures { get; set; }
        public int TotalLectures { get; set; }
        public string Status { get; set; } // Active, Completed, Inactive
        public DateTime? LastActivity { get; set; }
        public string LastActivityDescription { get; set; }
    }

    public class StudentDetailsDto
    {
        public StudentDto Student { get; set; }
        public List<StudentEnrollmentDto> Enrollments { get; set; }
        public StudentStatisticsDto Statistics { get; set; }
        public List<StudentActivityDto> RecentActivities { get; set; }
    }

    public class StudentStatisticsDto
    {
        public int TotalEnrollments { get; set; }
        public int CompletedCourses { get; set; }
        public int ActiveCourses { get; set; }
        public decimal AverageProgress { get; set; }
        public int TotalTimeSpent { get; set; } // in minutes
        public decimal AverageGrade { get; set; }
    }

    public class StudentActivityDto
    {
        public string Type { get; set; } // Video, Quiz, Assignment, Completion, Certificate
        public string Description { get; set; }
        public DateTime ActivityDate { get; set; }
        public string CourseTitle { get; set; }
        public int CourseId { get; set; }
    }

    public class StudentFilterDto
    {
        public string Search { get; set; }
        public int? CourseId { get; set; }
        public string Status { get; set; } // All, Active, Inactive, Completed
        public int PageNumber { get; set; } = 1;
        public int PageSize { get; set; } = 10;
    }

    public class StudentsSummaryDto
    {
        public int TotalStudents { get; set; }
        public int ActiveStudents { get; set; }
        public int CompletedCourses { get; set; }
        public decimal AverageCompletion { get; set; }
    }

    public class BulkMessageDto
    {
        public List<string> StudentIds { get; set; }
        public string Subject { get; set; }
        public string Message { get; set; }
        public bool SendEmail { get; set; } = true;
        public bool SendNotification { get; set; } = true;
    }

    public class StudentProgressDto
    {
        public int EnrollmentId { get; set; }
        public int CourseId { get; set; }
        public string CourseTitle { get; set; }
        public decimal ProgressPercentage { get; set; }
        public int CompletedLectures { get; set; }
        public int TotalLectures { get; set; }
        public DateTime? LastActivity { get; set; }
        public string Status { get; set; }
    }
}