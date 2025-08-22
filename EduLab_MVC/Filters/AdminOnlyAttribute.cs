using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Mvc;
using EduLab_Shared.Utitlites;

namespace EduLab_MVC.Filters
{
    public class AdminOnlyAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext context)
        {
            var userRole = context.HttpContext.Request.Cookies["UserRole"];

            if (string.IsNullOrEmpty(userRole) || userRole != SD.Admin)
            {
                context.Result = new RedirectToRouteResult(new RouteValueDictionary(
                new { area = "Learner", controller = "Error", action = "Error403" }
                ));
            }

            base.OnActionExecuting(context);
        }

    }

}
