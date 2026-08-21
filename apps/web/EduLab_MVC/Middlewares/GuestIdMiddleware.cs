namespace EduLab_MVC.Middlewares
{
    /// <summary>
    /// Ensures every visitor has a GuestId cookie so guest carts can be tracked before login.
    /// </summary>
    public class GuestIdMiddleware
    {
        private readonly RequestDelegate _next;

        /// <summary>
        /// Initializes a new instance of the <see cref="GuestIdMiddleware"/> class.
        /// </summary>
        /// <param name="next">The next middleware in the pipeline.</param>
        public GuestIdMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        /// <summary>
        /// Issues a GuestId cookie when one is not already present.
        /// </summary>
        /// <param name="context">The HTTP context.</param>
        /// <returns>A task representing the asynchronous operation.</returns>
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
