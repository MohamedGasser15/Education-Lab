using AutoMapper;
using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Auth;
using EduLab_Shared.DTOs.Category;
using EduLab_Shared.DTOs.Course;
using EduLab_Shared.DTOs.Lecture;
using EduLab_Shared.DTOs.Profile;
using EduLab_Shared.DTOs.Section;
using EduLab_Shared.DTOs.Settings;

namespace EduLab_API.MappingConfig
{
    public class MappingConfig : Profile
    {
        public MappingConfig()
        {
            // User Mappings
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

            // Category Mappings
            CreateMap<Category, CategoryDTO>().ReverseMap();
            CreateMap<Category, CategoryCreateDTO>().ReverseMap();
            CreateMap<Category, CategoryUpdateDTO>().ReverseMap();

            // Course Mappings
            CreateMap<Course, CourseDTO>().ReverseMap();
            CreateMap<CourseUpdateDTO, Course>()
                .ForAllMembers(opts => opts.Condition((src, dest, srcMember) => srcMember != null));

            // Section Mappings
            CreateMap<SectionDTO, Section>().ReverseMap();

            // Lecture Mappings
            CreateMap<LectureDTO, Lecture>().ReverseMap();

            // Settings Mappings
            CreateMap<ApplicationUser, GeneralSettingsDTO>()
                .ForMember(dest => dest.Email, opt => opt.MapFrom(src => src.Email))
                .ForMember(dest => dest.FullName, opt => opt.MapFrom(src => src.FullName))
                .ForMember(dest => dest.PhoneNumber, opt => opt.MapFrom(src => src.PhoneNumber));

            // Other Mappings
            CreateMap<UserSession, ActiveSessionDTO>();
            CreateMap<CertificateDTO, Certificate>().ReverseMap();
            CreateMap<InstructorProfileDTO, ApplicationUser>()
                .ReverseMap()
                .ForMember(dest => dest.FullName, opt => opt.MapFrom(src => src.Email));
        }
    }
}