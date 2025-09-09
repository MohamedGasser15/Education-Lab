using EduLab_MVC.Models.DTOs.Auth;
using EduLab_MVC.Models.DTOs.Token;
using EduLab_MVC.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.IdentityModel.Tokens.Jwt;

namespace EduLab_MVC.Areas.Learner.Controllers
{
    [Area("Learner")]
    [AllowAnonymous]
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
                    var profileImage = response.User.ProfileImageUrl ?? "";

                    // حفظ التوكنز في الكوكيز
                    _authService.SaveTokensToCookies(
                        response.Token,
                        response.RefreshToken,
                        response.RefreshTokenExpiry
                    );

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

                    Response.Cookies.Append("ProfileImageUrl", profileImage, new CookieOptions
                    {
                        Expires = DateTime.UtcNow.AddDays(7),
                        IsEssential = true,
                        HttpOnly = false
                    });

                    HttpContext.Session.SetString("JWToken", response.Token);
                    HttpContext.Session.SetString("UserFullName", fullNameClaim);
                    HttpContext.Session.SetString("UserRole", roleClaim);
                    HttpContext.Session.SetString("ProfileImageUrl", profileImage);

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
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> RefreshToken([FromBody] RefreshTokenRequestDTO request)
        {
            try
            {
                var result = await _authService.RefreshToken(request);
                if (result != null)
                {
                    _authService.SaveTokensToCookies(
                        result.AccessToken,
                        result.RefreshToken,
                        result.RefreshTokenExpiry
                    );

                    return Json(new { success = true, accessToken = result.AccessToken });
                }

                return Json(new { success = false, error = "Failed to refresh token" });
            }
            catch (UnauthorizedAccessException ex)
            {
                return Json(new { success = false, error = ex.Message });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, error = "An error occurred" });
            }
        }

        public IActionResult Register() => View();

        [HttpPost]
        public async Task<IActionResult> Register([FromBody] RegisterRequestDTO model)
        {
            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage).ToList();
                return Json(new { isSuccess = false, errorMessages = errors });
            }

            var response = await _authService.Register(model);

            if (response.IsSuccess)
            {
                TempData["SuccessMessage"] = "تم إنشاء الحساب بنجاح! يرجى تسجيل الدخول";
                return Json(new { isSuccess = true });
            }
            else
            {
                var errors = response.ErrorMessages ?? new List<string>();
                return Json(new { isSuccess = false, errorMessages = errors });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> VerifyEmail([FromBody] VerifyEmailDTO dto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(new { message = "البيانات المدخلة غير صحيحة" });
            }

            var response = await _authService.VerifyEmailCode(dto);

            if (response.IsSuccess)
            {
                return Ok(new { message = "تم تأكيد البريد الإلكتروني بنجاح" });
            }
            else
            {
                var errorMessage = response.ErrorMessages?.FirstOrDefault() ?? "الكود غير صحيح";
                return BadRequest(new { message = errorMessage });
            }
        }


        [HttpPost]
        public async Task<IActionResult> SendCode([FromBody] SendCodeDTO dto)
        {
            var response = await _authService.SendVerificationCode(dto);
            return Json(response);
        }

        [HttpGet]
        public IActionResult ExternalLoginCallbackFromApi(string email, bool isNewUser)
        {
            if (isNewUser)
            {
                var model = new ExternalLoginConfirmationDto
                {
                    Email = email
                };
                return View("ExternalLoginConfirmation", model);
            }

            TempData["Success"] = "تم تسجيل الدخول بنجاح.";
            return RedirectToAction("Index", "Home");
        }



        [HttpPost]
        public async Task<IActionResult> ExternalLoginConfirmation(ExternalLoginConfirmationDto model)
        {
            if (!ModelState.IsValid)
                return View(model);

            var response = await _authService.ConfirmExternalUser(model);


            if (!response.IsSuccess)
            {

                foreach (var error in response.ErrorMessages)
                {
                    ModelState.AddModelError(string.Empty, error);
                }
                return View(model);
            }

            TempData["Success"] = "تم إنشاء الحساب بنجاح.";
            return RedirectToAction("Index", "Home");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Logout()
        {
            var refreshToken = Request.Cookies["RefreshToken"];
            if (!string.IsNullOrEmpty(refreshToken))
            {
                await _authService.RevokeToken(refreshToken);
            }

            var options = new CookieOptions
            {
                Path = "/",
                Expires = DateTimeOffset.UnixEpoch
            };

            Response.Cookies.Delete("AuthToken");
            Response.Cookies.Delete("RefreshToken");
            Response.Cookies.Delete("RefreshTokenExpiry");
            Response.Cookies.Delete("UserFullName");
            Response.Cookies.Delete("UserRole");
            HttpContext.Session.Clear();

            Console.WriteLine("Logout method called + cookies deleted");

            return RedirectToAction("Index", "Home");
        }
    }

}
