using EduLab_Shared.DTOs.Instructor;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IInstructorService
    {
        Task<InstructorListDTO> GetAllInstructorsAsync();
        Task<InstructorDTO> GetInstructorByIdAsync(string id);
        Task<List<InstructorDTO>> GetTopRatedInstructorsAsync(int count);
    }
}
