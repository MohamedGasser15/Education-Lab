using Microsoft.AspNetCore.Identity;

namespace EduLab_API.Models
{
    public class ApplicationUser : IdentityUser
    {
        public string FullName { get; set; }
        public string Role { get; set; }
    }
}
