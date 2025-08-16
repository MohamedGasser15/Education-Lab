using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Auth;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Caching.Memory;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    public class UserService : IUserService
    {
        private readonly IUserRepository _userRepository;
        public readonly ITokenService _tokenService;
        private readonly IMapper _mapper;
        protected APIResponse _response;
        private readonly IMemoryCache _cache;
        private readonly IEmailSender _emailSender;
        private readonly IEmailTemplateService _emailTemplateService;
        private readonly IHistoryService _historyService;
        private readonly ICurrentUserService _currentUserService;
        public UserService(
            IUserRepository userRepository,
            ITokenService tokenService,
            IMapper mapper,
            IMemoryCache cache,
            IEmailSender emailSender,
            IEmailTemplateService emailTemplateService,
            UserManager<ApplicationUser> userManager,
            IHistoryService historyService,
            IHttpContextAccessor httpContextAccessor,
            ICurrentUserService currentUserService)
        {
            _userRepository = userRepository;
            _tokenService = tokenService;
            _mapper = mapper;
            _cache = cache;
            _response = new();
            _emailSender = emailSender;
            _emailTemplateService = emailTemplateService;
            _historyService = historyService;
            _currentUserService = currentUserService;
        }


        public async Task<APIResponse> Register(RegisterRequestDTO request)
        {
            if (!_cache.TryGetValue($"emailConfirmed:{request.Email}", out _))
            {
                _response.IsSuccess = false;
                _response.ErrorMessages = new List<string> { "يجب تأكيد البريد الإلكتروني أولاً قبل التسجيل." };
                _response.StatusCode = HttpStatusCode.BadRequest;
                return _response;
            }

            if (await _userRepository.IsEmailExistsAsync(request.Email))
            {
                _response.IsSuccess = false;
                _response.ErrorMessages = new List<string> { "هذا البريد الإلكتروني مستخدم مسبقاً" };
                _response.StatusCode = HttpStatusCode.BadRequest;
                return _response;
            }

            if (await _userRepository.IsFullNameExistsAsync(request.FullName))
            {
                _response.IsSuccess = false;
                _response.ErrorMessages = new List<string> { "هذا الاسم مستخدم مسبقاً" };
                _response.StatusCode = HttpStatusCode.BadRequest;
                return _response;
            }

            var user = new ApplicationUser
            {
                UserName = request.Email,
                Email = request.Email,
                FullName = request.FullName,
                EmailConfirmed = true
            };

            var result = await _userRepository.CreateUser(user, request.Password);

            if (!result.Succeeded)
            {
                _response.IsSuccess = false;
                _response.ErrorMessages = result.Errors.Select(e => e.Description).ToList();
                _response.StatusCode = HttpStatusCode.BadRequest;
                return _response;
            }

            _cache.Remove($"emailConfirmed:{request.Email}");

            _response.IsSuccess = true;
            _response.Result = _mapper.Map<UserDTO>(user);
            _response.StatusCode = HttpStatusCode.OK;

            return _response;
        }

        public async Task<APIResponse> VerifyEmailCodeAsync(string email, string code)
        {
            if (!_cache.TryGetValue($"verify:{email}", out string cachedCode))
            {
                return new APIResponse
                {
                    IsSuccess = false,
                    ErrorMessages = new List<string> { "انتهت صلاحية الكود أو غير موجود" },
                    StatusCode = HttpStatusCode.BadRequest
                };
            }

            if (cachedCode != code)
            {
                return new APIResponse
                {
                    IsSuccess = false,
                    ErrorMessages = new List<string> { "الكود غير صحيح" },
                    StatusCode = HttpStatusCode.BadRequest
                };
            }

            _cache.Set($"emailConfirmed:{email}", true, TimeSpan.FromMinutes(30));

            _cache.Remove($"verify:{email}");

            return new APIResponse
            {
                IsSuccess = true,
                StatusCode = HttpStatusCode.OK,
                Result = "تم تأكيد البريد الإلكتروني بنجاح"
            };
        }

        public async Task<APIResponse> SendVerificationCodeAsync(string email)
        {
            if (await _userRepository.IsEmailExistsAsync(email))
            {
                return new APIResponse
                {
                    IsSuccess = false,
                    ErrorMessages = new List<string> { "هذا البريد الإلكتروني مستخدم مسبقاً" },
                    StatusCode = HttpStatusCode.BadRequest
                };
            }

            var code = new Random().Next(100000, 999999).ToString();
            _cache.Set($"verify:{email}", code, TimeSpan.FromMinutes(10));

            var emailBody = _emailTemplateService.GenerateVerificationEmail(code);

            await _emailSender.SendEmailAsync(email, "رمز تأكيد البريد الإلكتروني", emailBody);

            return new APIResponse
            {
                IsSuccess = true,
                StatusCode = HttpStatusCode.OK,
                Result = "تم إرسال كود التفعيل إلى بريدك الإلكتروني"
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
                IsLocked = user.IsLocked,
                CreatedAt = user.CreatedAt
            }).ToList();
        }
        public async Task<bool> DeleteUserAsync(string id)
        {
            var user = await _userRepository.GetUserById(id);
            var result = await _userRepository.DeleteUserAsync(id);

            if (result && user != null)
            {
                var currentUserId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(currentUserId))
                {
                    await _historyService.LogOperationAsync(
                        currentUserId,
                        $"قام المستخدم بحذف مستخدم [ID: {user.Id.Substring(0, 3)}...] باسم \"{user.FullName}\"."
                    );
                }
            }

            return result;
        }

        public async Task<bool> DeleteRangeUserAsync(List<string> userIds)
        {
            var (Success, DeletedUserNames) = await _userRepository.DeleteRangeUserAsync(userIds);

            if (Success && DeletedUserNames.Any())
            {
                var currentUserId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(currentUserId))
                {
                    var names = string.Join(", ", DeletedUserNames);
                    await _historyService.LogOperationAsync(
                        currentUserId,
                        $"قام المستخدم بحذف مجموعة من المستخدمين ({names})."
                    );
                }
            }

            return Success;
        }

        public async Task<bool> UpdateUserAsync(UpdateUserDTO dto)
        {
            var result = await _userRepository.UpdateUserAsync(dto.Id, dto.FullName, dto.Role);

            if (result.Succeeded)
            {
                var currentUserId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(currentUserId))
                {
                    await _historyService.LogOperationAsync(
                        currentUserId,
                        $"قام المستخدم بتحديث بيانات المستخدم [ID: {dto.Id.Substring(0, 3)}...] باسم \"{dto.FullName}\"."
                    );
                }
            }

            return result.Succeeded;
        }

        public async Task<List<UserDTO>> GetInstructorsAsync()
        {
            var instructors = await _userRepository.GetInstructorsAsync();
            return instructors.Select(user => new UserDTO
            {
                Id = user.Id,
                FullName = user.FullName,
                Email = user.Email,
                Role = user.Role,
                IsLocked = user.IsLocked,
                CreatedAt = user.CreatedAt
            }).ToList();
        }
        public async Task<List<UserDTO>> GetAdminsAsync()
        {
            var admins = await _userRepository.GetAdminsAsync();
            return admins.Select(user => new UserDTO
            {
                Id = user.Id,
                FullName = user.FullName,
                Email = user.Email,
                Role = user.Role,
                IsLocked = user.IsLocked,
                CreatedAt = user.CreatedAt
            }).ToList();
        }
        public async Task LockUsersAsync(List<string> userIds, int minutes)
        {
            var lockedUsers = await _userRepository.LockUsersAsync(userIds, minutes);

            if (lockedUsers.Any())
            {
                var currentUserId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(currentUserId))
                {
                    var namesWithIds = string.Join(", ", lockedUsers.Select(u => $"[ID: {u.Id.Substring(0, 3)}...] {u.FullName}"));
                    await _historyService.LogOperationAsync(
                        currentUserId,
                        $"قام المستخدم بقفل حسابات المستخدمين التالية لمدة {minutes} دقيقة: {namesWithIds}."
                    );
                }
            }
        }

        public async Task UnlockUsersAsync(List<string> userIds)
        {
            var unlockedUsers = await _userRepository.UnlockUsersAsync(userIds);

            if (unlockedUsers.Any())
            {
                var currentUserId = await _currentUserService.GetUserIdAsync();
                if (!string.IsNullOrEmpty(currentUserId))
                {
                    var namesWithIds = string.Join(", ", unlockedUsers.Select(u => $"[ID: {u.Id.Substring(0, 3)}...] {u.FullName}"));
                    await _historyService.LogOperationAsync(
                        currentUserId,
                        $"قام المستخدم بفك قفل حسابات المستخدمين التالية: {namesWithIds}."
                    );
                }
            }
        }

    }
}
