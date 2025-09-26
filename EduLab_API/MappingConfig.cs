using AutoMapper;
using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Auth;
using EduLab_Shared.DTOs.Category;
using EduLab_Shared.DTOs.Course;
using EduLab_Shared.DTOs.Enrollment;
using EduLab_Shared.DTOs.Lecture;
using EduLab_Shared.DTOs.Profile;
using EduLab_Shared.DTOs.Section;
using EduLab_Shared.DTOs.Settings;
using System;
using System.Linq;

namespace EduLab_API.MappingConfig
{
    /// <summary>
    /// AutoMapper configuration profile
    /// </summary>
    public class MappingConfig : Profile
    {
        /// <summary>
        /// Initializes a new instance of the MappingConfig class
        /// </summary>
        public MappingConfig()
        {
            #region User Mappings

            CreateMap<ApplicationUser, UserDTO>()
                .ForMember(dest => dest.Role, opt => opt.Ignore())
                .ReverseMap()
                .ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.Email));

            CreateMap<ApplicationUser, ProfileDTO>()
                .ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id))
                .ForMember(dest => dest.FullName, opt => opt.MapFrom(src => src.FullName))
                .ForMember(dest => dest.Email, opt => opt.MapFrom(src => src.Email))
                .ForMember(dest => dest.Title, opt => opt.MapFrom(src => src.Title))
                .ForMember(dest => dest.Location, opt => opt.MapFrom(src => src.Location))
                .ForMember(dest => dest.PhoneNumber, opt => opt.MapFrom(src => src.PhoneNumber))
                .ForMember(dest => dest.About, opt => opt.MapFrom(src => src.About))
                .ForMember(dest => dest.ProfileImageUrl, opt => opt.MapFrom(src => src.ProfileImageUrl))
                .ForMember(dest => dest.CreatedAt, opt => opt.MapFrom(src => src.CreatedAt))
                .ForMember(dest => dest.SocialLinks, opt => opt.Ignore())
                .ReverseMap()
                .ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.Email));

            CreateMap<ApplicationUser, UserInfoDTO>()
                .ForMember(dest => dest.Role, opt => opt.Ignore())
                .ReverseMap()
                .ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.Email));

            #endregion

            #region Category Mappings

            CreateMap<Category, CategoryDTO>().ReverseMap();
            CreateMap<Category, CategoryCreateDTO>().ReverseMap();
            CreateMap<Category, CategoryUpdateDTO>().ReverseMap();

            #endregion

            #region Course Mappings

            CreateMap<Course, CourseDTO>()
                .ForMember(dest => dest.Status, opt => opt.MapFrom(src => src.Status.ToString()))
                .ForMember(dest => dest.CategoryName, opt => opt.MapFrom(src => src.Category.Category_Name))
                .ForMember(dest => dest.InstructorName, opt => opt.MapFrom(src => src.Instructor.FullName))
                .ForMember(dest => dest.TotalLectures, opt => opt.MapFrom(src => src.Sections.Sum(s => s.Lectures.Count)))
                .ReverseMap()
                .ForMember(dest => dest.Status, opt => opt.MapFrom(src => Enum.Parse<Coursestatus>(src.Status)));

            CreateMap<CourseCreateDTO, Course>()
                .ForMember(dest => dest.Status, opt => opt.MapFrom(src => Enum.Parse<Coursestatus>(src.Status)))
                .ForMember(dest => dest.ThumbnailUrl, opt => opt.MapFrom(src =>
                    string.IsNullOrEmpty(src.ThumbnailUrl) ? "/images/Courses/default.jpg" : src.ThumbnailUrl))
                .ForMember(dest => dest.Sections, opt => opt.MapFrom(src => src.Sections));

            CreateMap<CourseUpdateDTO, Course>()
                .ForMember(dest => dest.Sections, opt => opt.MapFrom(src => src.Sections))
                .ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null));

            #endregion

            #region Section Mappings

            CreateMap<SectionDTO, Section>()
                .ForMember(dest => dest.Lectures, opt => opt.MapFrom(src => src.Lectures))
                .ReverseMap()
                .ForMember(dest => dest.Lectures, opt => opt.MapFrom(src => src.Lectures));

            CreateMap<Section, SectionDTO>()
                .ForMember(dest => dest.Lectures, opt => opt.MapFrom(src => src.Lectures));

            #endregion

            #region Lecture Mappings

            CreateMap<LectureDTO, Lecture>()
                .ForMember(d => d.ContentType, opt => opt.MapFrom<ContentTypeResolver>())
                .ReverseMap()
                .ForMember(d => d.ContentType, opt => opt.MapFrom(s => s.ContentType.ToString()));

            CreateMap<Lecture, LectureDTO>()
                .ForMember(dest => dest.ContentType, opt => opt.MapFrom(src => src.ContentType.ToString()));

            #endregion

            #region Lecture Resource Mappings

            CreateMap<LectureResource, LectureResourceDTO>().ReverseMap();
            CreateMap<Lecture, LectureDTO>()
                .ForMember(dest => dest.Resources, opt => opt.MapFrom(src => src.Resources))
                .ReverseMap();

            #endregion

            #region Settings Mappings

            CreateMap<ApplicationUser, GeneralSettingsDTO>()
                .ForMember(dest => dest.Email, opt => opt.MapFrom(src => src.Email))
                .ForMember(dest => dest.FullName, opt => opt.MapFrom(src => src.FullName))
                .ForMember(dest => dest.PhoneNumber, opt => opt.MapFrom(src => src.PhoneNumber))
                .ReverseMap()
                .ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.Email))
                .ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null));

            CreateMap<UserSession, ActiveSessionDTO>()
               .ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id))
               .ForMember(dest => dest.DeviceInfo, opt => opt.MapFrom(src => src.DeviceInfo))
               .ForMember(dest => dest.Location, opt => opt.MapFrom(src => src.Location))
               .ForMember(dest => dest.LoginTime, opt => opt.MapFrom(src => src.LoginTime))
               .ForMember(dest => dest.IsCurrent, opt => opt.Ignore())
               .ReverseMap()
               .ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null));

            #endregion

            #region Enrollment Mappings
            CreateMap<Enrollment, EnrollmentDto>()
                           // Map Course Properties
                           .ForMember(dest => dest.Title, opt => opt.MapFrom(src => src.Course.Title))
                           .ForMember(dest => dest.ShortDescription, opt => opt.MapFrom(src => src.Course.ShortDescription))
                           .ForMember(dest => dest.Description, opt => opt.MapFrom(src => src.Course.Description))
                           .ForMember(dest => dest.Status, opt => opt.MapFrom(src => src.Course.Status.ToString()))
                           .ForMember(dest => dest.Price, opt => opt.MapFrom(src => src.Course.Price))
                           .ForMember(dest => dest.Discount, opt => opt.MapFrom(src => src.Course.Discount))
                           .ForMember(dest => dest.ThumbnailUrl, opt => opt.MapFrom(src => src.Course.ThumbnailUrl))
                           .ForMember(dest => dest.CreatedAt, opt => opt.MapFrom(src => src.Course.CreatedAt))
                           .ForMember(dest => dest.InstructorId, opt => opt.MapFrom(src => src.Course.InstructorId))
                           .ForMember(dest => dest.InstructorName, opt => opt.MapFrom(src => src.Course.Instructor.FullName))
                           .ForMember(dest => dest.InstructorAbout, opt => opt.MapFrom(src => src.Course.Instructor.About))
                           .ForMember(dest => dest.InstructorTitle, opt => opt.MapFrom(src => src.Course.Instructor.Title))
                           .ForMember(dest => dest.InstructorSubjects, opt => opt.MapFrom(src => src.Course.Instructor.Subjects))
                           .ForMember(dest => dest.ProfileImageUrl, opt => opt.MapFrom(src => src.Course.Instructor.ProfileImageUrl))
                           .ForMember(dest => dest.CategoryId, opt => opt.MapFrom(src => src.Course.CategoryId))
                           .ForMember(dest => dest.CategoryName, opt => opt.MapFrom(src => src.Course.Category.Category_Name))
                           .ForMember(dest => dest.Level, opt => opt.MapFrom(src => src.Course.Level))
                           .ForMember(dest => dest.Language, opt => opt.MapFrom(src => src.Course.Language))
                           .ForMember(dest => dest.Duration, opt => opt.MapFrom(src => src.Course.Duration))
                           .ForMember(dest => dest.TotalLectures, opt => opt.MapFrom(src => src.Course.Sections.Sum(s => s.Lectures.Count)))
                           .ForMember(dest => dest.HasCertificate, opt => opt.MapFrom(src => src.Course.HasCertificate))
                           .ForMember(dest => dest.Requirements, opt => opt.MapFrom(src => src.Course.Requirements))
                           .ForMember(dest => dest.Learnings, opt => opt.MapFrom(src => src.Course.Learnings))
                           .ForMember(dest => dest.TargetAudience, opt => opt.MapFrom(src => src.Course.TargetAudience))

                           // Map Enrollment Properties
                           .ForMember(dest => dest.EnrolledAt, opt => opt.MapFrom(src => src.EnrolledAt))
                           .ForMember(dest => dest.ProgressPercentage, opt => opt.MapFrom(src => 0)); 
        #endregion

        #region Profile Mappings

        CreateMap<ApplicationUser, InstructorProfileDTO>()
                .IncludeBase<ApplicationUser, ProfileDTO>()
                .ForMember(dest => dest.Subjects, opt => opt.MapFrom(src => src.Subjects))
                .ForMember(dest => dest.Certificates, opt => opt.MapFrom(src => src.Certificates))
                .ForMember(dest => dest.Courses, opt => opt.Ignore());


            CreateMap<Certificate, CertificateDTO>()
                .ReverseMap();

            CreateMap<CertificateDTO, Certificate>()
                .ForMember(dest => dest.UserId, opt => opt.Ignore())
                .ForMember(dest => dest.User, opt => opt.Ignore());

            CreateMap<ApplicationUser, SocialLinksDTO>()
                .ForMember(dest => dest.GitHub, opt => opt.MapFrom(src => src.GitHubUrl))
                .ForMember(dest => dest.LinkedIn, opt => opt.MapFrom(src => src.LinkedInUrl))
                .ForMember(dest => dest.Twitter, opt => opt.MapFrom(src => src.TwitterUrl))
                .ForMember(dest => dest.Facebook, opt => opt.MapFrom(src => src.FacebookUrl))
                .ReverseMap()
                .ForMember(dest => dest.GitHubUrl, opt => opt.MapFrom(src => src.GitHub))
                .ForMember(dest => dest.LinkedInUrl, opt => opt.MapFrom(src => src.LinkedIn))
                .ForMember(dest => dest.TwitterUrl, opt => opt.MapFrom(src => src.Twitter))
                .ForMember(dest => dest.FacebookUrl, opt => opt.MapFrom(src => src.Facebook));

            #endregion

        }

        public class ContentTypeResolver : IValueResolver<LectureDTO, Lecture, ContentType>
        {
            public ContentType Resolve(LectureDTO src, Lecture dest, ContentType destMember, ResolutionContext context)
            {
                if (string.IsNullOrWhiteSpace(src.ContentType)) return ContentType.Video;
                return Enum.TryParse<ContentType>(src.ContentType.Trim(), true, out var parsed)
                    ? parsed
                    : ContentType.Video;
            }
        }
    }
}