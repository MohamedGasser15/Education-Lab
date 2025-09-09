using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.Entities
{
    public class RefreshToken
    {
        public int Id { get; set; }
        public string UserId { get; set; } 
        public string Token { get; set; }
        public DateTime Expiry { get; set; }
        public DateTime CreatedAt { get; set; }
        public bool IsRevoked { get; set; }

        [ForeignKey("UserId")]
        public ApplicationUser User { get; set; }
    }
}
