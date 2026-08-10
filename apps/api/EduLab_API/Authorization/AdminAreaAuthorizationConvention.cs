using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc.ApplicationModels;
using Microsoft.AspNetCore.Mvc.Authorization;
using System.Linq;

namespace EduLab_API.Authorization
{
    public class AdminAreaAuthorizationConvention : IControllerModelConvention
    {
        public void Apply(ControllerModel controller)
        {
            if (controller.ControllerType.Namespace?.Contains(".Controllers.Admin") != true)
                return;

            // Only auto-protect controllers that do NOT declare explicit authorization.
            // Controllers/actions with explicit [Authorize] may be user-facing
            // (e.g. Admin/UserController "me" serves any authenticated user).
            var hasExplicitAuthorization = controller.Attributes.OfType<AuthorizeAttribute>().Any()
                || controller.Actions.Any(a => a.Attributes.OfType<AuthorizeAttribute>().Any());

            if (!hasExplicitAuthorization)
            {
                controller.Filters.Add(new AuthorizeFilter("AdminArea"));
            }
        }
    }
}
