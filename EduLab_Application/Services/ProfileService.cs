using AutoMapper;
using EduLab_Application.ServiceInterfaces;
using EduLab_Domain.Entities;
using EduLab_Domain.RepoInterfaces;
using EduLab_Shared.DTOs.Profile;
using Microsoft.AspNetCore.Hosting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.Services
{
    public class ProfileService : IProfileService
    {
        private readonly IProfileRepository _profileRepository;
        private readonly IMapper _mapper;
        private readonly IWebHostEnvironment _webHostEnvironment;
        private readonly ICourseService _courseService;

        public ProfileService(
            IProfileRepository profileRepository,
            IMapper mapper,
            IWebHostEnvironment webHostEnvironment, ICourseService courseService)
        {
            _profileRepository = profileRepository;
            _mapper = mapper;
            _webHostEnvironment = webHostEnvironment;
            _courseService = courseService;
        }

        public async Task<ProfileDTO> GetUserProfileAsync(string userId)
        {
            var user = await _profileRepository.GetUserProfileAsync(userId);
            if (user == null) return null;

            var profileDto = _mapper.Map<ProfileDTO>(user);

            // تعيين روابط التواصل
            profileDto.SocialLinks = new SocialLinksDTO
            {
                GitHub = user.GitHubUrl,
                LinkedIn = user.LinkedInUrl,
                Twitter = user.TwitterUrl,
                Facebook = user.FacebookUrl
            };

            return profileDto;
        }

        public async Task<bool> UpdateUserProfileAsync(UpdateProfileDTO updateProfileDto)
        {
            var user = await _profileRepository.GetUserProfileAsync(updateProfileDto.Id);
            if (user == null) return false;

            // تحديث الخصائص الأساسية
            user.FullName = updateProfileDto.FullName ?? user.FullName;
            user.Title = updateProfileDto.Title ?? user.Title;
            user.Location = updateProfileDto.Location ?? user.Location;
            user.PhoneNumber = updateProfileDto.PhoneNumber ?? user.PhoneNumber;
            user.About = updateProfileDto.About ?? user.About;

            // تحديث روابط التواصل
            if (updateProfileDto.SocialLinks != null)
            {
                user.GitHubUrl = updateProfileDto.SocialLinks.GitHub;
                user.LinkedInUrl = updateProfileDto.SocialLinks.LinkedIn;
                user.TwitterUrl = updateProfileDto.SocialLinks.Twitter;
                user.FacebookUrl = updateProfileDto.SocialLinks.Facebook;
            }

            return await _profileRepository.UpdateUserProfileAsync(user);
        }

        public async Task<string> UploadProfileImageAsync(ProfileImageDTO profileImageDto)
        {
            if (profileImageDto.ImageFile == null || profileImageDto.ImageFile.Length == 0)
                throw new ArgumentException("لم يتم تحميل صورة");

            // إنشاء مجلد التحميل إذا لم يكن موجوداً
            var uploadsFolder = Path.Combine(_webHostEnvironment.WebRootPath, "Images", "profiles");
            if (!Directory.Exists(uploadsFolder))
                Directory.CreateDirectory(uploadsFolder);

            // إنشاء اسم فريد للملف
            var uniqueFileName = $"{Guid.NewGuid()}_{profileImageDto.ImageFile.FileName}";
            var filePath = Path.Combine(uploadsFolder, uniqueFileName);

            // حفظ الملف
            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await profileImageDto.ImageFile.CopyToAsync(stream);
            }

            // إنشاء رابط الصورة
            var imageUrl = $"/Images/profiles/{uniqueFileName}";

            // تحديث رابط الصورة في قاعدة البيانات
            var success = await _profileRepository.UpdateProfileImageAsync(profileImageDto.UserId, imageUrl);

            if (!success)
                throw new Exception("فشل في تحديث صورة البروفايل");

            return imageUrl;
        }

        public async Task<InstructorProfileDTO> GetInstructorProfileAsync(string userId, int latestCoursesCount = 2)
        {
            var user = await _profileRepository.GetInstructorProfileAsync(userId);
            if (user == null) return null;

            var profileDto = _mapper.Map<InstructorProfileDTO>(user);

            // روابط التواصل
            profileDto.SocialLinks = new SocialLinksDTO
            {
                GitHub = user.GitHubUrl,
                LinkedIn = user.LinkedInUrl,
                Twitter = user.TwitterUrl,
                Facebook = user.FacebookUrl
            };

            // Subjects + Certificates
            profileDto.Subjects = user.Subjects ?? new List<string>();
            profileDto.Certificates = user.Certificates?
                .Select(c => _mapper.Map<CertificateDTO>(c))
                .ToList() ?? new List<CertificateDTO>();

            // 🔑 جلب أحدث الكورسات
            var latestCourses = await _courseService.GetLatestInstructorCoursesAsync(user.Id, latestCoursesCount);
            profileDto.Courses = latestCourses.ToList();

            return profileDto;
        }
        public async Task<InstructorProfileDTO> GetPublishInstructorProfileAsync(string userId)
        {
            var user = await _profileRepository.GetInstructorProfileAsync(userId);
            if (user == null) return null;

            var profileDto = _mapper.Map<InstructorProfileDTO>(user);

            // روابط التواصل
            profileDto.SocialLinks = new SocialLinksDTO
            {
                GitHub = user.GitHubUrl,
                LinkedIn = user.LinkedInUrl,
                Twitter = user.TwitterUrl,
                Facebook = user.FacebookUrl
            };

            // Subjects + Certificates
            profileDto.Subjects = user.Subjects ?? new List<string>();
            profileDto.Certificates = user.Certificates?
                .Select(c => _mapper.Map<CertificateDTO>(c))
                .ToList() ?? new List<CertificateDTO>();

            // 🔑 جلب أحدث الكورسات
            var latestCourses = await _courseService.GetLatestInstructorCoursesAsync(user.Id);
            profileDto.Courses = latestCourses.ToList();

            return profileDto;
        }
        public async Task<bool> UpdateInstructorProfileAsync(UpdateInstructorProfileDTO updateProfileDto)
        {
            var user = await _profileRepository.GetInstructorProfileAsync(updateProfileDto.Id);
            if (user == null) return false;

            user.FullName = updateProfileDto.FullName ?? user.FullName;
            user.Title = updateProfileDto.Title ?? user.Title;
            user.Location = updateProfileDto.Location ?? user.Location;
            user.PhoneNumber = updateProfileDto.PhoneNumber ?? user.PhoneNumber;
            user.About = updateProfileDto.About ?? user.About;

            if (updateProfileDto.Subjects != null)
            {
                user.Subjects = updateProfileDto.Subjects;
            }

            if (updateProfileDto.SocialLinks != null)
            {
                user.GitHubUrl = updateProfileDto.SocialLinks.GitHub;
                user.LinkedInUrl = updateProfileDto.SocialLinks.LinkedIn;
                user.TwitterUrl = updateProfileDto.SocialLinks.Twitter;
                user.FacebookUrl = updateProfileDto.SocialLinks.Facebook;
            }

            return await _profileRepository.UpdateInstructorProfileAsync(user);
        }

        public async Task<string> UploadInstructorProfileImageAsync(ProfileImageDTO profileImageDto)
        {
            if (profileImageDto.ImageFile == null || profileImageDto.ImageFile.Length == 0)
                throw new ArgumentException("لم يتم تحميل صورة");

            var uploadsFolder = Path.Combine(_webHostEnvironment.WebRootPath, "Images", "instructor_profiles");
            if (!Directory.Exists(uploadsFolder))
                Directory.CreateDirectory(uploadsFolder);

            var uniqueFileName = $"{Guid.NewGuid()}_{profileImageDto.ImageFile.FileName}";
            var filePath = Path.Combine(uploadsFolder, uniqueFileName);

            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await profileImageDto.ImageFile.CopyToAsync(stream);
            }

            var imageUrl = $"/Images/instructor_profiles/{uniqueFileName}";
            var success = await _profileRepository.UpdateProfileImageAsync(profileImageDto.UserId, imageUrl);

            if (!success)
                throw new Exception("فشل في تحديث صورة البروفايل");

            return imageUrl;
        }

        public async Task<CertificateDTO> AddCertificateAsync(string userId, CertificateDTO dto)
        {
            var cert = _mapper.Map<Certificate>(dto);
            cert.UserId = userId;
            var addedCert = await _profileRepository.AddCertificateAsync(cert);
            if (addedCert == null) return null;
            return _mapper.Map<CertificateDTO>(addedCert);
        }

        public async Task<bool> DeleteCertificateAsync(string userId, int certId)
        {
            return await _profileRepository.DeleteCertificateAsync(certId, userId);
        }
    }
}
