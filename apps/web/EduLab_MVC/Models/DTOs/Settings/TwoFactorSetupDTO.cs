namespace EduLab_MVC.Models.DTOs.Settings
{
    /// <summary>
    /// Represents a two factor setup data transfer object.
    /// </summary>
    public class TwoFactorSetupDTO
    {
        public string QrCodeUrl { get; set; }
        public string Secret { get; set; }
        public List<string> RecoveryCodes { get; set; }
    }
}
