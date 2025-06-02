// Sidebar Toggle
document.getElementById('toggle-sidebar').addEventListener('click', function () {
    const sidebar = document.getElementById('sidebar');
    const icon = this.querySelector('i');

    sidebar.classList.toggle('sidebar-collapsed');

    if (sidebar.classList.contains('sidebar-collapsed')) {
        icon.classList.remove('fa-chevron-right');
        icon.classList.add('fa-chevron-left');
        this.querySelector('.sidebar-item-text').textContent = 'فتح القائمة';
    } else {
        icon.classList.remove('fa-chevron-left');
        icon.classList.add('fa-chevron-right');
        this.querySelector('.sidebar-item-text').textContent = 'طي القائمة';
    }

    // Store sidebar state in localStorage
    localStorage.setItem('sidebarCollapsed', sidebar.classList.contains('sidebar-collapsed'));
});

// Mobile Menu Toggle
document.getElementById('mobile-menu-button').addEventListener('click', function () {
    document.getElementById('sidebar').classList.toggle('hidden');
});

// Close sidebar when clicking outside on mobile
document.addEventListener('click', function (event) {
    const sidebar = document.getElementById('sidebar');
    const mobileMenuButton = document.getElementById('mobile-menu-button');

    if (window.innerWidth <= 768 &&
        !sidebar.contains(event.target) &&
        event.target !== mobileMenuButton &&
        !mobileMenuButton.contains(event.target)) {
        sidebar.classList.add('hidden');
    }
});

// Theme Toggle
document.getElementById('theme-toggle').addEventListener('click', function () {
    document.documentElement.classList.toggle('dark');
    localStorage.setItem('theme', document.documentElement.classList.contains('dark') ? 'dark' : 'light');
});

// Check for saved theme preference
if (localStorage.getItem('theme') === 'dark' || (!localStorage.getItem('theme') && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
    document.documentElement.classList.add('dark');
}

// Check for saved sidebar state
if (localStorage.getItem('sidebarCollapsed') === 'true') {
    document.getElementById('sidebar').classList.add('sidebar-collapsed');
    const toggleButton = document.getElementById('toggle-sidebar');
    const icon = toggleButton.querySelector('i');
    icon.classList.remove('fa-chevron-right');
    icon.classList.add('fa-chevron-left');
    toggleButton.querySelector('.sidebar-item-text').textContent = 'فتح القائمة';
}

// Accordion for sidebar groups
document.querySelectorAll('.sidebar-group-header').forEach(header => {
    header.addEventListener('click', function () {
        const content = this.nextElementSibling;
        const icon = this.querySelector('.fa-chevron-down');
        content.classList.toggle('hidden');
        icon.classList.toggle('rotate-180');
    });
});

// Auto expand active group
document.querySelectorAll('.sidebar-group-content a').forEach(link => {
    if (link.classList.contains('text-primary-600') || link.classList.contains('bg-gray-100')) {
        link.closest('.sidebar-group-content').classList.remove('hidden');
        link.closest('.sidebar-group').querySelector('.fa-chevron-down').classList.add('rotate-180');
    }
});

// Handle window resize
window.addEventListener('resize', function () {
    if (window.innerWidth > 768) {
        document.getElementById('sidebar').classList.remove('hidden');
    }
});
document.addEventListener('DOMContentLoaded', function () {
    const notificationsButton = document.getElementById('notifications-button');
    const notificationsDropdown = document.getElementById('notifications-dropdown');
    const notificationBadge = document.getElementById('notification-badge');
    const markAllReadButton = document.getElementById('mark-all-read');

    // Toggle dropdown visibility
    notificationsButton.addEventListener('click', function (e) {
        e.stopPropagation();
        notificationsDropdown.classList.toggle('hidden');

        // Hide badge when dropdown is opened
        if (!notificationsDropdown.classList.contains('hidden')) {
            notificationBadge.classList.add('hidden');
        }
    });

    // Mark all as read
    markAllReadButton.addEventListener('click', function (e) {
        e.stopPropagation();
        // Remove unread styles from all notifications
        document.querySelectorAll('.bg-blue-50').forEach(el => {
            el.classList.remove('bg-blue-50', 'dark:bg-gray-700/50');
        });
        notificationBadge.classList.add('hidden');
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', function () {
        notificationsDropdown.classList.add('hidden');
    });

    // Prevent dropdown from closing when clicking inside
    notificationsDropdown.addEventListener('click', function (e) {
        e.stopPropagation();
    });
});