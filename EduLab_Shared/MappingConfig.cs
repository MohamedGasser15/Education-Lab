using AutoMapper;
using EduLab_Domain.Entities;
using EduLab_Shared.DTOs.Auth;

namespace EduLab_Shared.MappingConfig
{
    public class MappingConfig : Profile
    {
        public MappingConfig()
        {
            CreateMap<ApplicationUser, UserDTO>().ReverseMap();
        }
    }
}
