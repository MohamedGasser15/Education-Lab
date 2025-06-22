using AutoMapper;
using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Auth;
using EduLab_Shared.DTOs.Category;
using EduLab_Shared.DTOs.Course;
using EduLab_Shared.DTOs.Lecture;
using EduLab_Shared.DTOs.Section;

namespace EduLab_API.MappingConfig
{
    public class MappingConfig : Profile
    {
        public MappingConfig()
        {
            CreateMap<ApplicationUser, UserDTO>().ReverseMap();

            CreateMap<Category, CategoryDTO>().ReverseMap();
            CreateMap<Category, CategoryCreateDTO>().ReverseMap();
            CreateMap<Category, CategoryUpdateDTO>().ReverseMap();

            CreateMap<Course, CourseDTO>().ReverseMap();
            CreateMap<CourseUpdateDTO, Course>();

            CreateMap<SectionDTO, Section>().ReverseMap();
            CreateMap<LectureDTO, Lecture>().ReverseMap();

        }
    }
}
