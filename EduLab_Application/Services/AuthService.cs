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
    public class AuthService : IAuthService
    {
        private readonly IUserRepository _userRepository;
        private readonly ITokenService _tokenService;
        private readonly IMapper _mapper;
        public AuthService(IUserRepository userRepository, ITokenService tokenService , IMapper mapper)
        {
            _userRepository = userRepository;
            _tokenService = tokenService;
            _mapper = mapper;
        }
        public async Task<LoginResponseDTO> Login(LoginRequestDTO request)
        {
            var user = await _userRepository.GetUserByUserName(request.Email);

            bool isValid = await _userRepository.CheckPassword(user, request.Password);

            if (user == null || isValid == false) // Fixed logical condition
            {
                return new LoginResponseDTO()
                {
                    Token = "", // Fixed initialization of Token
                    User = null
                };
            }

            var token = await _tokenService.GenerateJwtToken(user);

            // Corrected mapping to UserDTO
            UserDTO userDTO = _mapper.Map<UserDTO>(user);

            return new LoginResponseDTO()
            {
                Token = token,
                User = userDTO
            };
        }
    }
}
