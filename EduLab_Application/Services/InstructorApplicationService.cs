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
        private readonly IInstructorApplicationRepository _applicationRepository;
        private readonly IEmailTemplateService _emailTemplateService;
        private readonly IEmailSender _emailSender;
        private readonly IHistoryService _historyService;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly ICurrentUserService _currentUserService;
        public InstructorApplicationService(
            UserManager<ApplicationUser> userManager,
            IWebHostEnvironment hostEnvironment,
            IInstructorApplicationRepository applicationRepository,
            RoleManager<IdentityRole> roleManager,
            IEmailTemplateService emailTemplateService,
            IEmailSender emailSender,
            IHistoryService historyService,
            ICurrentUserService currentUserService)
        {
            _userManager = userManager;
            _hostEnvironment = hostEnvironment;
            _applicationRepository = applicationRepository;
            _roleManager = roleManager;
            _emailTemplateService = emailTemplateService;
            _emailSender = emailSender;
            _historyService = historyService;
            _currentUserService = currentUserService;
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
                CvUrl = app.CvUrl,
                ProfileImageUrl = app.User?.ProfileImageUrl
            }).ToList();
        }

        public async Task<(bool Success, string Message)> ApproveApplication(string applicationId, string reviewedByUserId)
        {
            var application = await _applicationRepository.GetAsync(a => a.Id.ToString() == applicationId);
            if (application == null)
                return (false, "الطلب غير موجود");

            var user = await _userManager.FindByIdAsync(application.UserId);
            if (user == null)
                return (false, "المستخدم غير موجود");

            // إزالة الأدوار الحالية
            var currentRoles = await _userManager.GetRolesAsync(user);
            if (currentRoles.Any())
                await _userManager.RemoveFromRolesAsync(user, currentRoles);

            // إضافة دور Instructor
            if (!await _roleManager.RoleExistsAsync(SD.Instructor))
                await _roleManager.CreateAsync(new IdentityRole(SD.Instructor));

            await _userManager.AddToRoleAsync(user, SD.Instructor);

            var approvalEmailContent = _emailTemplateService.GenerateInstructorApprovalEmail(user);
            await _emailSender.SendEmailAsync(user.Email, "مبروك! تم قبولك كمدرب في EduLab", approvalEmailContent);

            // تحديث حالة الطلب (Approved)
            await _applicationRepository.UpdateStatusAsync(application.Id, "Approved", reviewedByUserId);

            // 🟢 إضافة تسجيل الـ History
            if (!string.IsNullOrEmpty(reviewedByUserId))
            {
                await _historyService.LogOperationAsync(
                    reviewedByUserId,
                    $"قام المستخدم بالموافقة على طلب الانضمام كمدرب للعضو ({user.FullName})."
                );
            }

            return (true, "تم قبول الطلب وتحويل المستخدم إلى مدرب");
        }



        public async Task<(bool Success, string Message)> RejectApplication(string applicationId, string reviewedByUserId)
        {
            var application = await _applicationRepository.GetAsync(a => a.Id.ToString() == applicationId);
            if (application == null)
                return (false, "الطلب غير موجود");

            var user = await _userManager.FindByIdAsync(application.UserId);
            if (user == null)
                return (false, "المستخدم غير موجود");

            // إزالة الأدوار الحالية
            var currentRoles = await _userManager.GetRolesAsync(user);
            if (currentRoles.Any())
                await _userManager.RemoveFromRolesAsync(user, currentRoles);

            // إضافة دور Student
            if (!await _roleManager.RoleExistsAsync(SD.Student))
                await _roleManager.CreateAsync(new IdentityRole(SD.Student));

            await _userManager.AddToRoleAsync(user, SD.Student);

            var rejectionEmailContent = _emailTemplateService.GenerateInstructorRejectionEmail(user);
            await _emailSender.SendEmailAsync(user.Email, "قرار بشأن طلب الانضمام كمدرب", rejectionEmailContent);

            // تحديث حالة الطلب (Rejected)
            await _applicationRepository.UpdateStatusAsync(application.Id, "Rejected", reviewedByUserId);

            // 🟢 إضافة تسجيل الـ History
            if (!string.IsNullOrEmpty(reviewedByUserId))
            {
                await _historyService.LogOperationAsync(
                    reviewedByUserId,
                    $"قام المستخدم برفض طلب الانضمام كمدرب للعضو ({user.FullName})."
                );
            }

            return (true, "تم رفض الطلب وإرجاع المستخدم إلى دوره الأساسي");
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
