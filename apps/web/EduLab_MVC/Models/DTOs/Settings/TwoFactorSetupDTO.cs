namespace EduLab_MVC.Models.DTOs.Settings
{
    public class TwoFactorSetupDTO
    {
        public string QrCodeUrl { get; set; }
        public string Secret { get; set; }
        public List<string> RecoveryCodes { get; set; }
    }
}