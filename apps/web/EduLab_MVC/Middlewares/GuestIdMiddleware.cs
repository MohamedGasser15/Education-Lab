namespace EduLab_MVC.Middlewares
{
    public class GuestIdMiddleware
    {
        private readonly RequestDelegate _next;

        public GuestIdMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            if (!context.Request.Cookies.ContainsKey("GuestId"))
            {
                var guestId = Guid.NewGuid().ToString();
                context.Response.Cookies.Append("GuestId", guestId, new CookieOptions
                {
                    Expires = DateTime.Now.AddDays(30),
                    HttpOnly = true,
                    IsEssential = true
                });
            }

            await _next(context);
        }
    }
}
