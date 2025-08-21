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
            CreateMap<ApplicationUser, UserDTO>().ReverseMap();

            CreateMap<ApplicationUser, ProfileDTO>()
            .ForMember(dest => dest.PhoneNumber, opt => opt.MapFrom(src => src.PhoneNumber))
            .ReverseMap();

            CreateMap<Category, CategoryDTO>().ReverseMap();
            CreateMap<Category, CategoryCreateDTO>().ReverseMap();
            CreateMap<Category, CategoryUpdateDTO>().ReverseMap();

            CreateMap<Course, CourseDTO>().ReverseMap();
            CreateMap<CourseUpdateDTO, Course>();

            CreateMap<SectionDTO, Section>().ReverseMap();
            CreateMap<LectureDTO, Lecture>().ReverseMap();

            CreateMap<ApplicationUser, GeneralSettingsDTO>()
            .ForMember(dest => dest.Email, opt => opt.MapFrom(src => src.Email))
            .ForMember(dest => dest.FullName, opt => opt.MapFrom(src => src.FullName))
            .ForMember(dest => dest.PhoneNumber, opt => opt.MapFrom(src => src.PhoneNumber));

            CreateMap<UserSession, ActiveSessionDTO>();
        }
    }
}
