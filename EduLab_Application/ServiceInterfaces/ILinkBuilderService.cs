using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EduLab_Application.ServiceInterfaces
{
    public interface ILinkBuilderService
    {
        string GenerateResetPasswordLink(string userId);
    }
}
