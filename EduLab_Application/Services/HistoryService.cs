using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.History;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    public class HistoryService : IHistoryService
    {
        private readonly IHistoryRepository _historyRepository;

        public HistoryService(IHistoryRepository historyRepository)
        {
            _historyRepository = historyRepository;
        }

        public async Task LogOperationAsync(string userId, string operation)
        {
            var log = new History
            {
                UserId = userId,
                Operation = operation,
                Date = DateOnly.FromDateTime(DateTime.Now),
                Time = TimeOnly.FromDateTime(DateTime.Now)
            };

            await _historyRepository.AddAsync(log);
        }

        public async Task<List<HistoryDTO>> GetAllHistoryAsync()
        {
            var logs = await _historyRepository.GetAllAsync(includeProperties: "User");

            return logs.Select(h => new HistoryDTO
            {
                Id = h.Id,
                UserName = h.User != null ? h.User.FullName : "Unknown",
                ProfileImageUrl = h.User?.ProfileImageUrl,
                Operation = h.Operation,
                Date = h.Date,
                Time = h.Time
            }).ToList();
        }

        public async Task<List<HistoryDTO>> GetHistoryByUserAsync(string userId)
        {
            var logs = await _historyRepository.GetByUserIdAsync(userId);

            return logs.Select(h => new HistoryDTO
            {
                Id = h.Id,
                UserName = h.User.FullName,
                ProfileImageUrl = h.User.ProfileImageUrl,
                Operation = h.Operation,
                Date = h.Date,
                Time = h.Time
            }).ToList();
        }

    }
}
