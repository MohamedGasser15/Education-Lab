let currentPage = 1;
const rowsPerPage = 10;
let allRows = [];

document.addEventListener('DOMContentLoaded', function () {
    initAlertSystem();
    initCategoryManagement();
});

// Alert System
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
    alert.className = `alert alert-${type} mx-auto max-w-4xl`;
    alert.id = alertId;
    alert.setAttribute('data-autohide', 'true');

    const icon = type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle';

    alert.innerHTML = `
            <div class="flex items-center">
                <i class="fas ${icon} alert-icon mr-3"></i>
                <div class="alert-content flex-grow">${message}</div>
                <button class="alert-close ml-4">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="alert-progress mt-2">
                <div class="alert-progress-bar h-1 bg-${type === 'success' ? 'green' : 'red'}-300"></div>
            </div>
        `;

    alertContainer.appendChild(alert);
    setupAlert(alert, duration);
}

function createAlertContainer() {
    const container = document.createElement('div');
    container.className = 'alert-container fixed top-4 left-0 right-0 z-50 w-full flex justify-center px-4';
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

function initCategoryManagement() {
    initPagination();
    document.getElementById('rows-per-page')?.addEventListener('change', function () {
        rowsPerPage = parseInt(this.value);
        displayPage(1); // Reset to first page with new rows per page
    });
    // Handle Add Category Button
    document.getElementById('add-category-btn')?.addEventListener('click', function () {
        document.getElementById('modal-action-type').textContent = 'إضافة';
        document.getElementById('category-form').reset();
        document.getElementById('category-id').value = '';
        document.getElementById('name-error').classList.add('hidden');
        document.getElementById('category-modal').classList.remove('hidden');
        document.getElementById('category-form').setAttribute('action', '/Admin/Category/Create');
    });

    document.getElementById('add-category-btn-empty')?.addEventListener('click', function () {
        document.getElementById('modal-action-type').textContent = 'إضافة';
        document.getElementById('category-form').reset();
        document.getElementById('category-id').value = '';
        document.getElementById('name-error').classList.add('hidden');
        document.getElementById('category-modal').classList.remove('hidden');
        document.getElementById('category-form').setAttribute('action', '/Admin/Category/Create');
    });

    // Handle Select All Checkbox
    document.getElementById('select-all')?.addEventListener('change', function () {
        const checkboxes = document.querySelectorAll('.category-checkbox');
        checkboxes.forEach(checkbox => {
            checkbox.checked = this.checked;
        });
        updateDeleteSelectedButton();
    });

    // Handle individual checkbox changes
    document.addEventListener('change', function (e) {
        if (e.target.classList.contains('category-checkbox')) {
            const allChecked = document.querySelectorAll('.category-checkbox:checked').length === document.querySelectorAll('.category-checkbox').length;
            document.getElementById('select-all').checked = allChecked;
            updateDeleteSelectedButton();
        }
    });

    // Update delete selected button visibility
    function updateDeleteSelectedButton() {
        const checkedCount = document.querySelectorAll('.category-checkbox:checked').length;
        const deleteSelectedBtn = document.getElementById('delete-selected-btn');
        const bulkActionsContainer = document.getElementById('bulkActionsContainer');
        const selectedCount = document.getElementById('selectedCount');

        if (checkedCount > 0) {
            bulkActionsContainer.classList.remove('hidden');
            selectedCount.textContent = checkedCount;
        } else {
            bulkActionsContainer.classList.add('hidden');
        }
    }

    // Handle Delete Selected Button
    document.getElementById('delete-selected-btn')?.addEventListener('click', function () {
        const selectedIds = Array.from(document.querySelectorAll('.category-checkbox:checked'))
            .map(checkbox => parseInt(checkbox.closest('tr').getAttribute('data-category-id')));

        if (selectedIds.length === 0) return;

        const messageHtml = `
                <div class="swal-custom-container">
                    <div class="swal-icon-container">
                        <i class="fas fa-trash-alt swal-trash-icon"></i>
                    </div>
                    <h3 class="swal-title">⚠️ تأكيد الحذف</h3>
                    <div class="swal-content">
                        <p class="swal-text">
                            هل أنت متأكد أنك تريد حذف
                            <strong class="swal-highlight">${selectedIds.length}</strong> تصنيفات؟
                        </p>
                        <div class="swal-warning">
                            <i class="fas fa-exclamation-circle swal-warning-icon"></i>
                            <span class="swal-warning-text">
                                لا يمكن التراجع عن هذا الحذف، سيتم حذف البيانات نهائيًا.
                            </span>
                        </div>
                    </div>
                </div>
            `;

        Swal.fire({
            html: messageHtml,
            showCancelButton: true,
            confirmButtonText: '<i class="fas fa-check-circle mr-1"></i> نعم، احذف',
            cancelButtonText: '<i class="fas fa-times-circle mr-1"></i> إلغاء',
            buttonsStyling: false,
            customClass: {
                popup: 'swal-no-border',
                actions: 'swal-actions',
                confirmButton: 'swal-confirm-btn',
                cancelButton: 'swal-cancel-btn'
            }
        }).then((result) => {
            if (result.isConfirmed) {
                fetch('/Category/DeleteRange', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'RequestVerificationToken': document.querySelector('input[name="__RequestVerificationToken"]').value
                    },
                    body: JSON.stringify({ ids: selectedIds })
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            Swal.fire({
                                icon: 'success',
                                title: 'تم الحذف بنجاح',
                                text: `تم حذف ${selectedIds.length} تصنيفات بنجاح`,
                                confirmButtonText: 'حسناً'
                            }).then(() => {
                                location.reload();
                            });
                        } else {
                            Swal.fire({
                                icon: 'error',
                                title: 'خطأ',
                                text: 'فشل في حذف التصنيفات المحددة',
                                confirmButtonText: 'حسناً'
                            });
                        }
                    })
                    .catch(error => {
                        Swal.fire({
                            icon: 'error',
                            title: 'خطأ',
                            text: 'حدث خطأ أثناء محاولة الحذف',
                            confirmButtonText: 'حسناً'
                        });
                    });
            }
        });
    });

    // Handle Edit Buttons using event delegation
    document.addEventListener('click', function (e) {
        if (e.target.closest('.edit-category-btn')) {
            const btn = e.target.closest('.edit-category-btn');
            const row = btn.closest('tr');
            const categoryId = btn.getAttribute('data-id');
            const categoryName = row.querySelector('td:nth-child(2) .text-sm.font-medium').textContent.trim();

            document.getElementById('modal-action-type').textContent = 'تعديل';
            document.getElementById('category-id').value = categoryId;
            document.getElementById('category-name').value = categoryName;
            document.getElementById('name-error').classList.add('hidden');
            document.getElementById('category-modal').classList.remove('hidden');
            document.getElementById('category-form').setAttribute('action', '/Admin/Category/Update');
        }

        // Handle Delete Buttons
        if (e.target.closest('.delete-category-btn')) {
            const btn = e.target.closest('.delete-category-btn');
            const categoryId = btn.getAttribute('data-id');
            const categoryName = btn.getAttribute('data-name');

            const messageHtml = `
                    <div class="swal-custom-container">
                        <div class="swal-icon-container">
                            <i class="fas fa-trash-alt swal-trash-icon"></i>
                        </div>
                        <h3 class="swal-title">⚠️ تأكيد الحذف</h3>
                        <div class="swal-content">
                            <p class="swal-text">
                                هل أنت متأكد أنك تريد حذف
                                <strong class="swal-highlight">${categoryName}</strong>؟
                            </p>
                            <div class="swal-warning">
                                <i class="fas fa-exclamation-circle swal-warning-icon"></i>
                                <span class="swal-warning-text">
                                    لا يمكن التراجع عن هذا الحذف، سيتم حذف البيانات نهائيًا.
                                </span>
                            </div>
                        </div>
                    </div>
                `;

            Swal.fire({
                html: messageHtml,
                showCancelButton: true,
                confirmButtonText: '<i class="fas fa-check-circle mr-1"></i> نعم، احذف',
                cancelButtonText: '<i class="fas fa-times-circle mr-1"></i> إلغاء',
                buttonsStyling: false,
                customClass: {
                    popup: 'swal-no-border',
                    actions: 'swal-actions',
                    confirmButton: 'swal-confirm-btn',
                    cancelButton: 'swal-cancel-btn'
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '/Admin/Category/Delete/' + categoryId;
                    form.style.display = 'none';

                    const tokenInput = document.createElement('input');
                    tokenInput.type = 'hidden';
                    tokenInput.name = '__RequestVerificationToken';
                    tokenInput.value = document.querySelector('input[name="__RequestVerificationToken"]').value;

                    form.appendChild(tokenInput);
                    document.body.appendChild(form);
                    form.submit();
                }
            });
        }

        // Handle Show Courses Buttons
        if (e.target.closest('.show-courses-btn')) {
            const btn = e.target.closest('.show-courses-btn');
            const categoryId = btn.getAttribute('data-category-id');
            const row = btn.closest('tr');
            const categoryName = row.querySelector('td:nth-child(2) .text-sm.font-medium').textContent.trim();

            // Show loading state
            const coursesList = document.getElementById('courses-list');
            coursesList.innerHTML = `
                    <tr>
                        <td colspan="3" class="px-3 py-4 text-center text-sm text-gray-500 dark:text-gray-400">
                            <i class="fas fa-spinner fa-spin mr-2"></i> جاري تحميل الكورسات...
                        </td>
                    </tr>
                `;

            document.getElementById('courses-modal-title').textContent = `الكورسات المرتبطة ب${categoryName}`;
            document.getElementById('courses-modal').classList.remove('hidden');

            // Fetch courses from server
            fetch(`/Category/GetCourses?categoryId=${categoryId}`)
                .then(response => response.json())
                .then(data => {
                    coursesList.innerHTML = '';

                    if (data.length === 0) {
                        coursesList.innerHTML = `
                                <tr>
                                    <td colspan="3" class="px-3 py-4 text-center text-sm text-gray-500 dark:text-gray-400">
                                        لا توجد كورسات مرتبطة بهذا التصنيف
                                    </td>
                                </tr>
                            `;
                    } else {
                        data.forEach(course => {
                            coursesList.innerHTML += `
                                    <tr class="hover:bg-gray-50 dark:hover:bg-gray-700">
                                        <td class="px-3 py-4 whitespace-nowrap text-sm font-medium text-gray-900 dark:text-white">
                                            ${course.name}
                                        </td>
                                        <td class="px-3 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400">
                                            ${course.instructor}
                                        </td>
                                        <td class="px-3 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400">
                                            ${course.price}
                                        </td>
                                    </tr>
                                `;
                        });
                    }
                })
                .catch(error => {
                    coursesList.innerHTML = `
                            <tr>
                                <td colspan="3" class="px-3 py-4 text-center text-sm text-gray-500 dark:text-gray-400">
                                    <i class="fas fa-exclamation-triangle mr-2"></i> حدث خطأ أثناء جلب بيانات الكورسات
                                </td>
                            </tr>
                        `;
                });
        }
    });

    // Handle form submission
    document.getElementById('category-form')?.addEventListener('submit', function (e) {
        e.preventDefault();
        const form = e.target;
        const categoryId = document.getElementById('category-id').value;
        const categoryName = document.getElementById('category-name').value.trim();

        if (!categoryName) {
            document.getElementById('name-error').classList.remove('hidden');
            return;
        }

        // Create a new form with the correct model binding names
        const submitForm = document.createElement('form');
        submitForm.method = 'POST';
        submitForm.action = form.getAttribute('action');
        submitForm.style.display = 'none';

        // Add the category name
        const nameInput = document.createElement('input');
        nameInput.type = 'hidden';
        nameInput.name = 'Category_Name';
        nameInput.value = categoryName;
        submitForm.appendChild(nameInput);

        // Add the category ID if we're updating
        if (categoryId) {
            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'Category_Id';
            idInput.value = categoryId;
            submitForm.appendChild(idInput);
        }

        // Add the antiforgery token
        const tokenInput = document.createElement('input');
        tokenInput.type = 'hidden';
        tokenInput.name = '__RequestVerificationToken';
        tokenInput.value = document.querySelector('input[name="__RequestVerificationToken"]').value;
        submitForm.appendChild(tokenInput);

        // Submit the form
        document.body.appendChild(submitForm);
        submitForm.submit();
    });

    // Close modals
    document.getElementById('cancel-modal-btn')?.addEventListener('click', function () {
        document.getElementById('category-modal').classList.add('hidden');
    });

    document.getElementById('close-courses-modal')?.addEventListener('click', function () {
        document.getElementById('courses-modal').classList.add('hidden');
    });

    // Search functionality
    document.getElementById('search-categories')?.addEventListener('input', function () {
        const searchTerm = this.value.toLowerCase();
        allRows = Array.from(document.querySelectorAll('tbody tr')).filter(row => {
            const categoryName = row.querySelector('td:nth-child(2) .text-sm.font-medium')?.textContent.toLowerCase() || '';
            return categoryName.includes(searchTerm);
        });

        // Reset to first page after search
        displayPage(1);
    });

    // Reset filters
    document.getElementById('resetFilters')?.addEventListener('click', function () {
        document.getElementById('search-categories').value = '';
        allRows = Array.from(document.querySelectorAll('tbody tr'));
        displayPage(1);
    });
}
// Initialize pagination
function initPagination() {
    // Get all table rows (excluding header)
    allRows = Array.from(document.querySelectorAll('tbody tr'));

    // Show initial page
    displayPage(1);

    // Update pagination controls
    updatePaginationControls();
}

// Display specific page
function displayPage(page) {
    currentPage = page;
    const start = (page - 1) * rowsPerPage;
    const end = start + rowsPerPage;
    const paginatedRows = allRows.slice(start, end);

    // Hide all rows first
    allRows.forEach(row => row.style.display = 'none');

    // Show only rows for current page
    paginatedRows.forEach(row => row.style.display = '');

    // Update pagination controls
    updatePaginationControls();

    // Scroll to top of table
    document.querySelector('table')?.scrollIntoView({ behavior: 'smooth' });
}

// Update pagination controls
function updatePaginationControls() {
    const totalRows = allRows.length;
    const totalPages = Math.ceil(totalRows / rowsPerPage);
    const paginationContainer = document.querySelector('.pagination-controls');

    if (!paginationContainer) return;

    // Clear existing controls
    paginationContainer.innerHTML = '';

    // Create previous button
    const prevButton = document.createElement('button');
    prevButton.innerHTML = '<i class="fas fa-chevron-right"></i>';
    prevButton.className = `pagination-btn ${currentPage === 1 ? 'disabled' : ''}`;
    prevButton.onclick = () => {
        if (currentPage > 1) displayPage(currentPage - 1);
    };
    paginationContainer.appendChild(prevButton);

    // Create page buttons
    for (let i = 1; i <= totalPages; i++) {
        const pageBtn = document.createElement('button');
        pageBtn.textContent = i;
        pageBtn.className = `pagination-btn ${currentPage === i ? 'active' : ''}`;
        pageBtn.onclick = () => displayPage(i);
        paginationContainer.appendChild(pageBtn);
    }

    // Create next button
    const nextButton = document.createElement('button');
    nextButton.innerHTML = '<i class="fas fa-chevron-left"></i>';
    nextButton.className = `pagination-btn ${currentPage === totalPages ? 'disabled' : ''}`;
    nextButton.onclick = () => {
        if (currentPage < totalPages) displayPage(currentPage + 1);
    };
    paginationContainer.appendChild(nextButton);

    // Update page info
    const pageInfo = document.querySelector('.page-info');
    if (pageInfo) {
        const startItem = (currentPage - 1) * rowsPerPage + 1;
        const endItem = Math.min(currentPage * rowsPerPage, totalRows);
        pageInfo.innerHTML = `
                عرض <span class="font-medium">${startItem}</span>
                إلى <span class="font-medium">${endItem}</span>
                من <span class="font-medium">${totalRows}</span> نتائج
            `;
    }
}