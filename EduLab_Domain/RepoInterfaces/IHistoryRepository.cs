using EduLab_Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Domain.RepoInterfaces
{
    public interface IHistoryRepository : IRepository<History>
    {
        Task AddAsync(History history);
        Task<List<History>> GetAllAsync();
        Task<List<History>> GetByUserIdAsync(string userId);
    }
}
