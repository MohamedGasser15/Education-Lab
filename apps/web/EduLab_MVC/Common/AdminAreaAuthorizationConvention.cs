using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ApplicationModels;
using Microsoft.AspNetCore.Mvc.Authorization;
using System.Linq;

namespace EduLab_MVC.Common
{
    public class AdminAreaAuthorizationConvention : IControllerModelConvention
    {
        public void Apply(ControllerModel controller)
        {
            if (controller.Attributes.Any(a => a is AreaAttribute area && area.RouteValue == "Admin"))
            {
                controller.Filters.Add(new AuthorizeFilter("AdminArea"));
            }
        }
    }
}
