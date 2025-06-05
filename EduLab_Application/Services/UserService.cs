using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Auth;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    public class UserService : IUserService
    {
        private readonly IUserRepository _userRepository;
        public readonly ITokenService _tokenService;
        private readonly IMapper _mapper;

        public UserService(IUserRepository userRepository, ITokenService tokenService, IMapper mapper)
        {
            _userRepository = userRepository;
            _tokenService = tokenService;
            _mapper = mapper;
        }

        public async Task<LoginResponseDTO> Register(RegisterRequestDTO request)
        {
            var user = new ApplicationUser()
            {
                UserName = request.Email,
                Email = request.Email,
                FullName = request.FullName
            };

            var result = await _userRepository.CreateUser(user, request.Password);

            if (result.Succeeded)
            {
                var roles = await _userRepository.GetUserRoles(user);
                user.Role = roles.FirstOrDefault(); // Assuming one role
                var token = await _tokenService.GenerateJwtToken(user);
                // Corrected mapping to UserDTO
                UserDTO userDTO = _mapper.Map<UserDTO>(user);

                return new LoginResponseDTO()
                {
                    Token = token,
                    User = userDTO
                };
            }

            return new LoginResponseDTO()
            {
                Token = null,
                User = null
            };
        }
        public async Task<List<UserDTO>> GetAllUsersWithRolesAsync()
        {
            var users = await _userRepository.GetAllUsersWithRolesAsync();

            return users.Select(user => new UserDTO
            {
                Id = user.Id,
                FullName = user.FullName,
                Email = user.Email,
                Role = user.Role,
                CreatedAt = user.CreatedAt
            }).ToList();
        }
        public async Task<bool> DeleteUserAsync(string id)
        {
            return await _userRepository.DeleteUserAsync(id);
        }

    }
}
