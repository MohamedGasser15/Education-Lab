using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Instructor;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;

namespace EduLab_Application.Services
{
    public class InstructorApplicationService : IInstructorApplicationService
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IWebHostEnvironment _hostEnvironment;
        private readonly IRepository<InstructorApplication> _applicationRepository;
        private readonly RoleManager<IdentityRole> _roleManager;
        public InstructorApplicationService(
            UserManager<ApplicationUser> userManager,
            IWebHostEnvironment hostEnvironment,
            IRepository<InstructorApplication> applicationRepository,
            RoleManager<IdentityRole> roleManager)
        {
            _userManager = userManager;
            _hostEnvironment = hostEnvironment;
            _applicationRepository = applicationRepository;
            _roleManager = roleManager;
        }

        public async Task<(bool Success, string Message)> SubmitApplication(InstructorApplicationDTO applicationDto, string userId)
        {
            var user = await _userManager.FindByIdAsync(userId);
            if (user == null)
                return (false, "المستخدم غير موجود");

            // 🔍 التحقق لو عنده طلب سابق لسه Pending أو Approved
            var existingApplication = (await _applicationRepository
                .GetAllAsync(a => a.UserId == userId))
                .OrderByDescending(a => a.AppliedDate)
                .FirstOrDefault();

            if (existingApplication != null &&
               (existingApplication.Status == "Pending" || existingApplication.Status == "Approved"))
            {
                // عنده طلب لسه جاري أو مقبول = منفعش يقدم تاني
                return (false, "لديك طلب سابق قيد المراجعة أو تم قبوله بالفعل");
            }

            // تحديث بيانات الـ User الأساسية
            user.FullName = applicationDto.FullName;
            user.PhoneNumber = applicationDto.Phone;
            user.About = applicationDto.Bio;
            user.Subjects = applicationDto.Skills;
            if (applicationDto.ProfileImage != null)
            {
                user.ProfileImageUrl = await SaveFile(applicationDto.ProfileImage, "Images/profiles");
            }

            await _userManager.UpdateAsync(user);

            // حذف الـ Roles القديمة
            var currentRoles = await _userManager.GetRolesAsync(user);
            if (currentRoles.Any())
            {
                await _userManager.RemoveFromRolesAsync(user, currentRoles);
            }

            // إضافة Role جديدة باسم Pending Instructor
            if (!await _roleManager.RoleExistsAsync(SD.InstructorPending))
            {
                await _roleManager.CreateAsync(new IdentityRole(SD.InstructorPending));
            }
            await _userManager.AddToRoleAsync(user, SD.InstructorPending);

            // حفظ CV
            string cvUrl = null; 
            if (applicationDto.CvFile != null)
            {
                cvUrl = await SaveFile(applicationDto.CvFile, "Images/cv-files");
            }

            // إنشاء InstructorApplication جديد
            var instructorApplication = new InstructorApplication
            {
                Id = Guid.NewGuid(),
                UserId = userId,
                Specialization = applicationDto.Specialization,
                Experience = applicationDto.Experience,
                Skills = string.Join(",", applicationDto.Skills),
                CvUrl = cvUrl,
                Status = "Pending",
                AppliedDate = DateTime.UtcNow
            };

            await _applicationRepository.CreateAsync(instructorApplication);

            return (true, "تم إرسال الطلب بنجاح وجاري مراجعته");
        }


        public async Task<List<InstructorApplicationResponseDto>> GetUserApplications(string userId)
        {
            var applications = await _applicationRepository
                .GetAllAsync(a => a.UserId == userId, includeProperties: "User");

            return applications.Select(app => new InstructorApplicationResponseDto
            {
                Id = app.Id.ToString(),
                FullName = app.User?.FullName,
                Email = app.User?.Email,
                Specialization = app.Specialization,
                Status = app.Status,
                AppliedDate = app.AppliedDate,
                CvUrl = app.CvUrl,
                Experience = app.Experience
            }).ToList();
        }

        public async Task<InstructorApplicationResponseDto> GetApplicationDetails(string userId, string applicationId)
        {
            var app = await _applicationRepository.GetAsync(
                a => a.UserId == userId && a.Id.ToString() == applicationId,
                includeProperties: "User"
            );

            if (app == null) return null;

            return new InstructorApplicationResponseDto
            {
                Id = app.Id.ToString(),
                FullName = app.User?.FullName,
                Email = app.User?.Email,
                Specialization = app.Specialization,
                Status = app.Status,
                AppliedDate = app.AppliedDate,
                CvUrl = app.CvUrl,
                Experience = app.Experience
            };
        }
        public async Task<List<AdminInstructorApplicationDto>> GetAllApplicationsForAdmin()
        {
            var applications = await _applicationRepository
                .GetAllAsync(includeProperties: "User");

            return applications.Select(app => new AdminInstructorApplicationDto
            {
                Id = app.Id.ToString(),
                UserId = app.UserId,
                FullName = app.User?.FullName,
                Email = app.User?.Email,
                Specialization = app.Specialization,
                Experience = app.Experience,
                Skills = app.Skills,
                Status = app.Status,
                AppliedDate = app.AppliedDate,
                ReviewedDate = app.ReviewedDate,
                ReviewedBy = app.ReviewedBy,
                CvUrl = app.CvUrl
            }).ToList();
        }

        public async Task<bool> ReviewApplication(string applicationId, string status, string reviewedByUserId)
        {
            var application = await _applicationRepository.GetAsync(
                a => a.Id.ToString() == applicationId);

            if (application == null) return false;

            application.Status = status;
            application.ReviewedDate = DateTime.UtcNow;
            application.ReviewedBy = reviewedByUserId;

            // إذا تم القبول، أضف دور Instructor للمستخدم
            if (status == "Approved")
            {
                var user = await _userManager.FindByIdAsync(application.UserId);
                if (user != null)
                {
                    // إزالة أي أدوار سابقة وإضافة دور Instructor
                    var currentRoles = await _userManager.GetRolesAsync(user);
                    await _userManager.RemoveFromRolesAsync(user, currentRoles);
                    await _userManager.AddToRoleAsync(user, SD.Instructor);
                }
            }

            await _applicationRepository.SaveAsync();
            return true;
        }
        private async Task<string> SaveFile(IFormFile file, string folderName)
        {
            if (file == null || file.Length == 0)
                return null;

            var uploadsFolder = Path.Combine(_hostEnvironment.WebRootPath, folderName);
            if (!Directory.Exists(uploadsFolder))
                Directory.CreateDirectory(uploadsFolder);

            var uniqueFileName = Guid.NewGuid().ToString() + "_" + file.FileName;
            var filePath = Path.Combine(uploadsFolder, uniqueFileName);

            using (var fileStream = new FileStream(filePath, FileMode.Create))
            {
                await file.CopyToAsync(fileStream);
            }

            return $"/{folderName}/{uniqueFileName}";
        }
    }
}
