using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Category
{
    public class CategoryDTO
    {
        [Key]
        public int Category_Id { get; set; }
        [Required]
        [MaxLength(30)]
        public string Category_Name { get; set; }
        public int CoursesCount { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
