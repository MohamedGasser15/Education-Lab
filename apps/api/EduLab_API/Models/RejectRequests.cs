namespace EduLab_API.Models
{
    /// <summary>
    /// Request body for rejecting a course
    /// </summary>
    public class RejectCourseRequest
    {
        public string? RejectionReason { get; set; }
    }

    /// <summary>
    /// Request body for rejecting an instructor application
    /// </summary>
    public class RejectApplicationRequest
    {
        public string? RejectionReason { get; set; }
    }
}
