namespace EduLab_MVC.Models.DTOs.Roles
{
    /// <summary>
    /// Represents a claim data transfer object.
    /// </summary>
    public class ClaimDto
    {
        public string Type { get; set; }
        public string Value { get; set; }
        public bool Selected { get; set; }
    }
}
