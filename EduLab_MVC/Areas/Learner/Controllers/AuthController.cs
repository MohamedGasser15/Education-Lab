using EduLab_MVC.Models;
using EduLab_MVC.Models.DTOs.Auth;
using EduLab_MVC.Services;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;

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
                    // تسجيل الدخول الناجح
                    TempData["SuccessMessage"] = "تم تسجيل الدخول بنجاح!";

                    // حفظ التوكن في الكوكيز أو الجلسة
                    Response.Cookies.Append("AuthToken", response.Token, new CookieOptions
                    {
                        HttpOnly = true,
                        Secure = true,
                        SameSite = SameSiteMode.Strict,
                        Expires = DateTime.UtcNow.AddDays(7)
                    });

                    return RedirectToAction("Index", "Home");
                }

                // في حالة فشل المصادقة
                TempData["ErrorMessage"] = "البريد الإلكتروني أو كلمة المرور غير صحيحة";
                return View(model);
            }
            catch (Exception ex)
            {
                // في حالة حدوث خطأ غير متوقع
                TempData["ErrorMessage"] = "حدث خطأ أثناء محاولة تسجيل الدخول. يرجى المحاولة مرة أخرى.";
                return View(model);
            }
        }

        public IActionResult Register() => View();

        [HttpPost]
        public async Task<IActionResult> Register(RegisterRequestDTO model)
        {
            if (!ModelState.IsValid)
            {
                TempData["ErrorMessage"] = "الرجاء إدخال جميع الحقول المطلوبة بشكل صحيح";
                return View(model);
            }

            try
            {
                var result = await _authService.Register(model);

                if (result)
                {
                    TempData["SuccessMessage"] = "تم إنشاء الحساب بنجاح! يرجى تسجيل الدخول";
                    return RedirectToAction("Login");
                }
                if (model.Password != model.Password)
                {
                    TempData["ErrorMessage"] = "كلمة المرور وتأكيدها غير متطابقين";
                    return View(model);
                }
                TempData["ErrorMessage"] = "فشل في إنشاء الحساب. قد يكون البريد الإلكتروني مستخدماً مسبقاً";
                return View(model);
            }
            catch (Exception ex)
            {
                // يمكنك تسجيل الخطأ هنا (logging)
                TempData["ErrorMessage"] = "حدث خطأ غير متوقع أثناء محاولة التسجيل. يرجى المحاولة مرة أخرى";
                return View(model);
            }
        }
    }

}
