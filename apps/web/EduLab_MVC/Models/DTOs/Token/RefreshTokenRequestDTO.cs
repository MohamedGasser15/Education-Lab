namespace EduLab_MVC.Models.DTOs.Token
{ 
    /// <summary>
    /// Represents a refresh token request data transfer object.
    /// </summary>
    public class RefreshTokenRequestDTO
    {
        public string AccessToken { get; set; }
        public string RefreshToken { get; set; }
    }
}
