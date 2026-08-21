namespace EduLab_MVC.Models
{
    /// <summary>
    /// View model that supplies data for the error view.
    /// </summary>
    public class ErrorViewModel
    {
        public string? RequestId { get; set; }

        public bool ShowRequestId => !string.IsNullOrEmpty(RequestId);
    }
}
