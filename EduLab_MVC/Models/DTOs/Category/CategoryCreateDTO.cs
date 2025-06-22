using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_MVC.Models.DTOs.Category
{
    public class CategoryCreateDTO
    {
        [Required]
        [MaxLength(30)]
        public string Category_Name { get; set; }
    }
}
