using Microsoft.AspNetCore.Authorization;
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
            var isAdminArea = controller.Attributes.Any(a => a is AreaAttribute area && area.RouteValue == "Admin");
            if (!isAdminArea)
                return;

            // Only auto-protect controllers that do NOT declare explicit authorization.
            // Controllers/actions with explicit [Authorize] may be user-facing.
            var hasExplicitAuthorization = controller.Attributes.OfType<AuthorizeAttribute>().Any()
                || controller.Actions.Any(a => a.Attributes.OfType<AuthorizeAttribute>().Any());

            if (!hasExplicitAuthorization)
            {
                controller.Filters.Add(new AuthorizeFilter("AdminArea"));
            }
        }
    }
}
