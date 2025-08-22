using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace EduLab_MVC.Filters
{
    public class InstructorOnlyAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext context)
        {
            var userRole = context.HttpContext.Request.Cookies["UserRole"];

            if (string.IsNullOrEmpty(userRole) || userRole != SD.Instructor)
            {
                context.Result = new RedirectToRouteResult(new RouteValueDictionary(
                    new { area = "Learner", controller = "Error", action = "Error403" }
                ));
            }

            base.OnActionExecuting(context);
        }
    }
}
