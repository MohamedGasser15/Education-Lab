namespace EduLab_MVC.Models.DTOs.Token
{
    /// <summary>
    /// Represents a token response data transfer object.
    /// </summary>
    public class TokenResponseDTO
    {
        public string AccessToken { get; set; }
        public string RefreshToken { get; set; }
        public DateTime RefreshTokenExpiry { get; set; }
    }
}
