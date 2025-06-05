document.addEventListener('DOMContentLoaded', function () {

    // ============ Password Visibility Toggle ============

        document.querySelectorAll('button[id^="toggle-password"]').forEach(function (button) {
            button.addEventListener('click', function () {
                const container = button.closest('.relative');
                const input = container.querySelector('input[type="password"], input[type="text"]');
                const icon = button.querySelector('i');

                if (input) {
                    const isPassword = input.getAttribute('type') === 'password';
                    input.setAttribute('type', isPassword ? 'text' : 'password');

                    if (icon) {
                        icon.classList.toggle('fa-eye-slash', !isPassword);
                        icon.classList.toggle('fa-eye', isPassword);
                    }
                }
            });
        });

    // ============ Confirm Password Visibility Toggle ============
    const confirmInput = document.getElementById('register-confirm-password');
    const toggleConfirm = document.getElementById('toggle-confirm-password');
    const confirmIcon = document.getElementById('confirm-password-icon');

    if (toggleConfirm && confirmInput && confirmIcon) {
        toggleConfirm.addEventListener('click', function () {
            const type = confirmInput.getAttribute('type') === 'password' ? 'text' : 'password';
            confirmInput.setAttribute('type', type);

            // Toggle icon
            confirmIcon.classList.toggle('fa-eye-slash');
            confirmIcon.classList.toggle('fa-eye');
        });
    }

    // ============ Form Submission ============
    const loginForm = document.querySelector('form');
    if (loginForm) {
        loginForm.addEventListener('submit', function (e) {
        });
    }
});