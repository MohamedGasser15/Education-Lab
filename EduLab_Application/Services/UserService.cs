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
                var token = await _tokenService.GenerateJwtToken(user);
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
    }
}
