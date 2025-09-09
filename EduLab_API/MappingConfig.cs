using AutoMapper;
using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Auth;
using EduLab_Shared.DTOs.Category;
using EduLab_Shared.DTOs.Course;
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
                .ForMember(dest => dest.PhoneNumber, opt => opt.MapFrom(src => src.PhoneNumber))
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

            #region Other Mappings

            CreateMap<UserSession, ActiveSessionDTO>();
            CreateMap<CertificateDTO, Certificate>().ReverseMap();
            CreateMap<InstructorProfileDTO, ApplicationUser>()
                .ReverseMap()
                .ForMember(dest => dest.FullName, opt => opt.MapFrom(src => src.Email));

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