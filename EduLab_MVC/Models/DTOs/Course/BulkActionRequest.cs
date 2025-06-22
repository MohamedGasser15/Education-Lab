namespace EduLab_MVC.Models.DTOs.Course
{
    public class BulkActionRequest
    {
        public List<int> Ids { get; set; }
        public string Action { get; set; }
    }
}
