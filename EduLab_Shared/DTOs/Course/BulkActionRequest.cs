using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Shared.DTOs.Course
{
    public class BulkActionRequest
    {
        public string Action { get; set; }
        public List<int> Ids { get; set; }
    }
}
