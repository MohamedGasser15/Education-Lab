namespace EduLab_MVC.Services.ServiceInterfaces
{
    /// <summary>
    /// Interface for creating authorized HTTP clients
    /// </summary>
    public interface IAuthorizedHttpClientService
    {
        /// <summary>
        /// Creates an HTTP client with authorization headers
        /// </summary>
        /// <returns>Configured HttpClient instance</returns>
        HttpClient CreateClient();
    }
}
