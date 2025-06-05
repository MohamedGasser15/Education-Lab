document.addEventListener('DOMContentLoaded', function () {
    console.log("Auth.js loaded");

    // Password Visibility Toggle
    document.querySelectorAll('button[id^="toggle-"]').forEach(function (button) {
        button.addEventListener('click', function () {
            const container = button.closest('.relative');
            const input = container.querySelector('input[type="password"], input[type="text"]');
            const icon = button.querySelector('i');

            if (input && icon) {
                const isPassword = input.getAttribute('type') === 'password';
                input.setAttribute('type', isPassword ? 'text' : 'password');
                icon.classList.toggle('fa-eye-slash', !isPassword);
                icon.classList.toggle('fa-eye', isPassword);
            }
        });
    });

    // Form Submission Handler for Register and Login
    const forms = [
        { selector: '#registerForm', buttonId: 'createAccountBtn', loadingText: 'جاري المعالجة...' },
        { selector: '#loginForm', buttonId: 'loginBtn', loadingText: 'جاري تسجيل الدخول...' }
    ];

    forms.forEach(formConfig => {
        const form = document.querySelector(formConfig.selector);
        if (form) {
            form.addEventListener('submit', function (e) {
                e.preventDefault();

                const btn = document.getElementById(formConfig.buttonId);
                if (!btn) {
                    console.error(`Button with ID ${formConfig.buttonId} not found`);
                    return;
                }

                const inputs = form.querySelectorAll('input:not([type="hidden"])');
                let hasInput = false;

                // Check if any input field has a value
                inputs.forEach(input => {
                    if (input.value.trim() !== '') {
                        hasInput = true;
                    }
                });

                // Only proceed if there is input
                if (hasInput) {
                    console.log(`Submitting ${formConfig.selector} with loading text: ${formConfig.loadingText}`);
                    btn.innerHTML = `<i class="fas fa-spinner fa-spin"></i> ${formConfig.loadingText}`;
                    btn.disabled = true;
                    // Force DOM repaint and delay submission
                    btn.offsetHeight; // Trigger reflow
                    setTimeout(() => {
                        form.submit(); // Let the backend handle the rest
                    }, 300);
                } else {
                    console.log(`Form ${formConfig.selector} not submitted: all inputs empty`);
                }
            });
        } else {
            console.error(`Form with selector ${formConfig.selector} not found`);
        }
    });
});