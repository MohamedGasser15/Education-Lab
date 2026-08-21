using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc.ApplicationModels;
using Microsoft.AspNetCore.Mvc.Authorization;
using System.Linq;

namespace EduLab_API.Authorization
{
    /// <summary>
    /// Applies the AdminArea authorization policy by default to controllers
    /// under the Controllers.Admin namespace, unless they declare explicit authorization
    /// </summary>
    public class AdminAreaAuthorizationConvention : IControllerModelConvention
    {
        /// <summary>
        /// Applies the AdminArea policy filter to the given controller if it has no explicit authorization attributes
        /// </summary>
        /// <param name="controller">The controller model being configured</param>
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
