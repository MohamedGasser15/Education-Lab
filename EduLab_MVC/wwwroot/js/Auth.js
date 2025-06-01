document.addEventListener('DOMContentLoaded', function () {

    // ============ Password Visibility Toggle ============
    const loginPasswordInput = document.getElementById('Password');
    const toggleLoginPassword = document.getElementById('toggle-password');
    const loginPasswordIcon = document.getElementById('password-icon');

    if (toggleLoginPassword && loginPasswordInput && loginPasswordIcon) {
        toggleLoginPassword.addEventListener('click', function () {
            const type = loginPasswordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            loginPasswordInput.setAttribute('type', type);

            // Toggle icon
            loginPasswordIcon.classList.toggle('fa-eye-slash');
            loginPasswordIcon.classList.toggle('fa-eye');
        });
    }

    // ============ Form Submission ============
    const loginForm = document.querySelector('form');
    if (loginForm) {
        loginForm.addEventListener('submit', function (e) {
        });
    }
});