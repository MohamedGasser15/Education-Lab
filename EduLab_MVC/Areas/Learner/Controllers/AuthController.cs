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
            var response = await _authService.Login(model);
            if (response != null && response.Token != null)
            {
                TempData["Token"] = response.Token;
                return RedirectToAction("Index", "Home");
            }

            ViewBag.Error = "Login Failed";
            return View(model);
        }

        public IActionResult Register() => View();

        [HttpPost]
        public async Task<IActionResult> Register(RegisterRequestDTO model)
        {
            var result = await _authService.Register(model);
            if (result)
                return RedirectToAction("Login");

            ViewBag.Error = "Registration Failed";
            return View(model);
        }
    }

}
