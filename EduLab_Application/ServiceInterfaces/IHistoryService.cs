using EduLab_Shared.DTOs.History;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IHistoryService
    {
        Task LogOperationAsync(string userId, string operation);
        Task<List<HistoryDTO>> GetAllHistoryAsync();
        Task<List<HistoryDTO>> GetHistoryByUserAsync(string userId);
    }
}
