using EduLab_Domain.Entities;
using EduLab_MVC.Models;
using EduLab_MVC.Models.DTOs.Auth;
using EduLab_MVC.Services;
using EduLab_Shared.Utitlites;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using System.IdentityModel.Tokens.Jwt;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    public class AuthController : Controller
    {
        private readonly AuthService _authService;
        public AuthController(AuthService authService)
        {
            _authService = authService;
        }

        public IActionResult Login() => View();

        [HttpPost]
        public async Task<IActionResult> Login(LoginRequestDTO model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            try
            {
                var response = await _authService.Login(model);

                if (!string.IsNullOrWhiteSpace(response?.Token) && response.User != null)
                {
                    TempData["SuccessMessage"] = "تم تسجيل الدخول بنجاح!";

                    var handler = new JwtSecurityTokenHandler();
                    var jwtToken = handler.ReadJwtToken(response.Token);

                    var roleClaim = jwtToken.Claims.FirstOrDefault(c => c.Type == "role")?.Value ?? "";
                    var fullNameClaim = jwtToken.Claims.FirstOrDefault(c => c.Type == "UserFullName")?.Value ?? response.User.FullName ?? "";

                    Response.Cookies.Append("AuthToken", response.Token, new CookieOptions
                    {
                        HttpOnly = true,
                        Secure = true,
                        SameSite = SameSiteMode.Strict,
                        Expires = DateTime.UtcNow.AddDays(7)
                    });

                    Response.Cookies.Append("UserFullName", fullNameClaim, new CookieOptions
                    {
                        Expires = DateTime.UtcNow.AddDays(7),
                        IsEssential = true,
                        HttpOnly = false
                    });

                    Response.Cookies.Append("UserRole", roleClaim, new CookieOptions
                    {
                        Expires = DateTime.UtcNow.AddDays(7),
                        IsEssential = true,
                        HttpOnly = false
                    });

                    HttpContext.Session.SetString("JWToken", response.Token);
                    HttpContext.Session.SetString("UserFullName", fullNameClaim);
                    HttpContext.Session.SetString("UserRole", roleClaim);

                    return RedirectToAction("Index", "Home");
                }

                TempData["ErrorMessage"] = "البريد الإلكتروني أو كلمة المرور غير صحيحة";
                return View(model);
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "حدث خطأ أثناء محاولة تسجيل الدخول. يرجى المحاولة مرة أخرى.";
                return View(model);
            }
        }

        public IActionResult Register() => View();

        [HttpPost]
        public async Task<IActionResult> Register(RegisterRequestDTO model)
        {
            if (!ModelState.IsValid)
                return View(model);

            var response = await _authService.Register(model);

            if (response.IsSuccess)
            {
                TempData["SuccessMessage"] = "تم إنشاء الحساب بنجاح! يرجى تسجيل الدخول";
                return RedirectToAction(nameof(Login));
            }
            else
            {
                foreach (var err in response.ErrorMessages)
                {
                    ModelState.AddModelError(string.Empty, err);
                }
                return View(model);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Logout()
        {
            var options = new CookieOptions
            {
                Path = "/",
                Expires = DateTimeOffset.UnixEpoch
            };

            Response.Cookies.Delete("AuthToken");
            Response.Cookies.Delete("UserFullName");
            Response.Cookies.Delete("UserRole");
            HttpContext.Session.Clear();


            Console.WriteLine("Logout method called + cookies deleted");

            return RedirectToAction("Index", "Home");
        }

    }

}
