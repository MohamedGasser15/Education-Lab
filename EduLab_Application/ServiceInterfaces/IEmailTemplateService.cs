using EduLab_Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface IEmailTemplateService
    {
        string GenerateLoginEmail(ApplicationUser user, string ipAddress, string deviceName, DateTime requestTime, string passwordResetLink);
    }
}
