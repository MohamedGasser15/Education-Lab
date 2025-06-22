using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.Entities
{
    public class Category
    {
        [Key]
        public int Category_Id { get; set; }

        [Required]
        public string Category_Name { get; set; }

        public DateTime CreatedAt { get; set; }

        public virtual ICollection<Course> Courses { get; set; }

        public Category()
        {
            Courses = new List<Course>();
        }
    }
}
