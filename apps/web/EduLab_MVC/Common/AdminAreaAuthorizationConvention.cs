using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ApplicationModels;
using Microsoft.AspNetCore.Mvc.Authorization;
using System.Linq;

namespace EduLab_MVC.Common
{
    /// <summary>
    /// Automatically applies the "AdminArea" authorization filter to admin controllers that do not declare explicit authorization.
    /// </summary>
    public class AdminAreaAuthorizationConvention : IControllerModelConvention
    {
        /// <summary>
        /// Applies the admin authorization filter to eligible controllers.
        /// </summary>
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
