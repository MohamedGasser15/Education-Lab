using Microsoft.AspNetCore.Mvc.ApplicationModels;
using Microsoft.AspNetCore.Mvc.Authorization;
using System.Linq;

namespace EduLab_API.Authorization
{
    public class AdminAreaAuthorizationConvention : IControllerModelConvention
    {
        public void Apply(ControllerModel controller)
        {
            if (controller.ControllerType.Namespace?.Contains(".Controllers.Admin") == true)
            {
                controller.Filters.Add(new AuthorizeFilter("AdminArea"));
            }
        }
    }
}
