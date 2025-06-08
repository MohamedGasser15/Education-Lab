// Dark mode and mobile menu functionality
document.addEventListener('DOMContentLoaded', function () {
    // Elements
    const html = document.documentElement;
    const themeToggles = document.querySelectorAll('#theme-toggle, #theme-toggle-mobile');
    const mobileMenuButton = document.getElementById('mobile-menu-button');
    const mobileMenu = document.getElementById('mobile-menu');

    // Check for saved theme preference
    const savedTheme = localStorage.getItem('theme') || 'light';
    if (savedTheme === 'dark') {
        html.classList.add('dark');
    }

    // Update all theme icons
    updateThemeIcons();

    // Theme toggle functionality
    themeToggles.forEach(toggle => {
        toggle.addEventListener('click', function (e) {
            e.stopPropagation(); // منع انتشار الحدث
            toggleTheme();
        });
    });

    // Mobile menu toggle
    mobileMenuButton.addEventListener('click', function (e) {
        e.stopPropagation(); // منع انتشار الحدث
        toggleMobileMenu();
    });

    // Close mobile menu when clicking outside
    document.addEventListener('click', function () {
        if (!mobileMenu.classList.contains('hidden')) {
            toggleMobileMenu();
        }
    });

    // Prevent mobile menu from closing when clicking inside it
    mobileMenu.addEventListener('click', function (e) {
        e.stopPropagation();
    });

    function toggleTheme() {
        html.classList.toggle('dark');
        const theme = html.classList.contains('dark') ? 'dark' : 'light';
        localStorage.setItem('theme', theme);
        updateThemeIcons();
    }

    function toggleMobileMenu() {
        mobileMenu.classList.toggle('hidden');
        mobileMenuButton.innerHTML = mobileMenu.classList.contains('hidden')
            ? '<i class="fas fa-bars text-xl"></i>'
            : '<i class="fas fa-times text-xl"></i>';
    }

    function updateThemeIcons() {
        const isDark = html.classList.contains('dark');
        themeToggles.forEach(toggle => {
            toggle.innerHTML = isDark
                ? '<i class="fas fa-sun"></i>'
                : '<i class="fas fa-moon"></i>';
        });
    }
    
    // Hero Slider
    const heroSwiper = new Swiper('.heroSwiper', {
        loop: true,
        autoplay: {
            delay: 5000,
            disableOnInteraction: false,
        },
        navigation: {
            nextEl: '.swiper-button-next',
            prevEl: '.swiper-button-prev',
        },
        pagination: {
            el: '.swiper-pagination',
            clickable: true,
        },
        effect: 'fade',
        fadeEffect: {
            crossFade: true
        },
        speed: 1000,
    });
});

//Questions section
// FAQ Toggle Functionality
document.querySelectorAll('.faq-toggle').forEach(button => {
    button.addEventListener('click', () => {
        const content = button.nextElementSibling;
        const icon = button.querySelector('i');

        // Toggle content
        content.classList.toggle('hidden');

        // Rotate icon
        icon.classList.toggle('rotate-180');
    });
});
// FAQ functionality
document.addEventListener('DOMContentLoaded', function () {
    // Toggle FAQ items
    document.querySelectorAll('.faq-toggle').forEach(button => {
        button.addEventListener('click', () => {
            const content = button.nextElementSibling;
            const icon = button.querySelector('i');

            content.classList.toggle('hidden');
            icon.classList.toggle('rotate-180');
        });
    });

    // Load more FAQs
    const faqContainer = document.getElementById('faq-container');
    const loadMoreBtn = document.getElementById('load-more-faq');

    if (loadMoreBtn) {
        loadMoreBtn.addEventListener('click', function () {
            // These could be loaded from an API in a real application
            const additionalFaqs = [
                {
                    question: "كيف يمكنني التواصل مع المدرب؟",
                    answer: "كل دورة تحتوي على قسم للأسئلة والأجوبة حيث يمكنك التواصل مع المدرب وزملائك الطلاب."
                },
                {
                    question: "هل يمكنني تحميل مواد الدورة؟",
                    answer: "نعم، معظم الدورات تتيح لك تحميل المواد التعليمية مثل ملفات PDF والعروض التقديمية."
                },
                {
                    question: "ماذا لو واجهت مشكلة تقنية؟",
                    answer: "يمكنك التواصل مع فريق الدعم الفني عبر صفحة اتصل بنا وسنقوم بمساعدتك في أسرع وقت ممكن."
                }
            ];

            additionalFaqs.forEach(faq => {
                const faqItem = document.createElement('div');
                faqItem.className = 'bg-white dark:bg-gray-800 rounded-lg shadow-md overflow-hidden';
                faqItem.innerHTML = `
                    <button class="faq-toggle w-full flex justify-between items-center p-6 text-left">
                        <h3 class="text-lg font-semibold text-gray-800 dark:text-white">
                            ${faq.question}
                        </h3>
                        <i class="fas fa-chevron-down text-blue-600 dark:text-blue-400 transition-transform"></i>
                    </button>
                    <div class="faq-content px-6 pb-6 hidden">
                        <p class="text-gray-600 dark:text-gray-300">
                            ${faq.answer}
                        </p>
                    </div>
                `;
                faqContainer.appendChild(faqItem);
            });

            // Re-attach event listeners to new FAQs
            document.querySelectorAll('.faq-toggle').forEach(button => {
                button.addEventListener('click', function () {
                    const content = this.nextElementSibling;
                    const icon = this.querySelector('i');

                    content.classList.toggle('hidden');
                    icon.classList.toggle('rotate-180');
                });
            });

            // Hide load more button after loading all FAQs
            loadMoreBtn.style.display = 'none';
        });
    }
});

// Messages 
// Function to show alert message
// Alert Message System - Right Side
document.addEventListener('DOMContentLoaded', function () {
    initAlertSystem();
});

function initAlertSystem() {
    // Create alert container if not exists
    if (!document.querySelector('.alert-container')) {
        const alertContainer = document.createElement('div');
        alertContainer.className = 'alert-container';
        document.body.appendChild(alertContainer);
    }

    // Process server-side alerts (from TempData)
    const serverAlerts = document.querySelectorAll('.alert-container .alert');
    serverAlerts.forEach(alert => {
        setupAlert(alert);
    });
}

function showAlert(type, message, duration = 5000) {
    const alertContainer = document.querySelector('.alert-container') || createAlertContainer();
    const alertId = 'alert-' + Date.now();

    const alert = document.createElement('div');
    alert.className = `alert alert-${type}`;
    alert.id = alertId;
    alert.setAttribute('data-autohide', 'true');

    const icon = type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle';

    alert.innerHTML = `
        <i class="fas ${icon} alert-icon"></i>
        <div class="alert-content">${message}</div>
        <button class="alert-close">
            <i class="fas fa-times"></i>
        </button>
        <div class="alert-progress">
            <div class="alert-progress-bar"></div>
        </div>
    `;

    alertContainer.appendChild(alert);
    setupAlert(alert, duration);
}

function createAlertContainer() {
    const container = document.createElement('div');
    container.className = 'alert-container';
    document.body.appendChild(container);
    return container;
}

function setupAlert(alert, duration = 5000) {
    // Show animation
    setTimeout(() => {
        alert.classList.add('show');
    }, 10);

    // Close button event
    const closeBtn = alert.querySelector('.alert-close');
    if (closeBtn) {
        closeBtn.addEventListener('click', () => hideAlert(alert));
    }

    // Auto-hide if enabled
    if (alert.dataset.autohide === 'true') {
        const progressBar = alert.querySelector('.alert-progress-bar');
        if (progressBar) {
            progressBar.style.transitionDuration = `${duration}ms`;
            progressBar.style.width = '0%';
            void progressBar.offsetWidth; // Trigger reflow
            progressBar.style.width = '100%';
        }

        setTimeout(() => {
            hideAlert(alert);
        }, duration);
    }
}

function hideAlert(alert) {
    if (!alert) return;

    alert.classList.remove('show');
    alert.classList.add('hide');

    setTimeout(() => {
        alert.remove();
    }, 400);
}

window.showAlert = showAlert;

// Search Toggle for Mobile
document.addEventListener('DOMContentLoaded', function () {
    const searchToggle = document.getElementById('search-toggle');
    const mobileSearch = document.getElementById('mobile-search');
    const mobileMenu = document.getElementById('mobile-menu');

    if (searchToggle && mobileSearch) {
        searchToggle.addEventListener('click', function (e) {
            e.stopPropagation();
            mobileSearch.classList.toggle('hidden');

            // Close mobile menu if open
            if (!mobileMenu.classList.contains('hidden')) {
                mobileMenu.classList.add('hidden');
            }
        });
    }

    // Close mobile search when clicking outside
    document.addEventListener('click', function () {
        if (mobileSearch && !mobileSearch.classList.contains('hidden')) {
            mobileSearch.classList.add('hidden');
        }
    });

    // Prevent mobile search from closing when clicking inside it
    if (mobileSearch) {
        mobileSearch.addEventListener('click', function (e) {
            e.stopPropagation();
        });
    }
});
// for navbar things
document.addEventListener('DOMContentLoaded', function () {
    const mobileMenuBtn = document.getElementById('mobile-menu-button');
    const mobileMenu = document.getElementById('mobile-menu');
    const mobileSearch = document.getElementById('mobile-search');
    const searchToggle = document.getElementById('search-toggle');

    if (mobileMenuBtn && mobileMenu) {
        mobileMenuBtn.addEventListener('click', function (e) {
            e.stopPropagation();

            if (mobileSearch && mobileSearch.classList.contains('show')) {
                mobileSearch.classList.remove('show');
                mobileSearch.style.maxHeight = '0';
            }

            mobileMenu.classList.toggle('show');
            mobileMenu.style.maxHeight = mobileMenu.classList.contains('show') ?
                mobileMenu.scrollHeight + 'px' : '0';
        });
    }

    if (searchToggle && mobileSearch) {
        searchToggle.addEventListener('click', function (e) {
            e.stopPropagation();

            if (mobileMenu && mobileMenu.classList.contains('show')) {
                mobileMenu.classList.remove('show');
                mobileMenu.style.maxHeight = '0';
            }

            mobileSearch.classList.toggle('show');
            mobileSearch.style.maxHeight = mobileSearch.classList.contains('show') ?
                '100px' : '0';
        });
    }

    document.addEventListener('click', function () {
        if (mobileMenu && mobileMenu.classList.contains('show')) {
            mobileMenu.classList.remove('show');
            mobileMenu.style.maxHeight = '0';
        }

        if (mobileSearch && mobileSearch.classList.contains('show')) {
            mobileSearch.classList.remove('show');
            mobileSearch.style.maxHeight = '0';
        }
    });

    const dropdownContents = document.querySelectorAll(
        '.dropdown-content, #mobile-menu, #mobile-search'
    );
    dropdownContents.forEach(element => {
        element.addEventListener('click', function (e) {
            e.stopPropagation();
        });
    });

    const mobileCategories = document.querySelectorAll('#mobile-menu .category-item');
    mobileCategories.forEach(item => {
        item.addEventListener('click', function () {
            mobileMenu.classList.remove('show');
            mobileMenu.style.maxHeight = '0';
        });
    });

    console.log('Script loaded successfully');
    console.log('Mobile Menu Button:', mobileMenuBtn);
    console.log('Mobile Menu:', mobileMenu);
});
