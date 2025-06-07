document.addEventListener('DOMContentLoaded', function () {
    // Initialize variables
    const rowsPerPage = 10;
    let currentPage = 1;
    let filteredRows = Array.from(document.querySelectorAll('.user-row'));
    const totalItems = document.getElementById('totalItems');
    const showingFrom = document.getElementById('showingFrom');
    const showingTo = document.getElementById('showingTo');
    const paginationNumbers = document.getElementById('paginationNumbers');
    const prevButton = document.getElementById('prevPage');
    const nextButton = document.getElementById('nextPage');
    const searchInput = document.getElementById('searchInput');
    const roleFilter = document.getElementById('roleFilter');
    const statusFilter = document.getElementById('statusFilter');

    // Filter users function
    function filterUsers() {
        const searchTerm = searchInput.value.toLowerCase();
        const roleValue = roleFilter.value;
        const statusValue = statusFilter.value;

        filteredRows = Array.from(document.querySelectorAll('.user-row')).filter(row => {
            const name = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
            const email = row.querySelector('td:nth-child(3)')?.textContent.toLowerCase() || '';
            const role = row.getAttribute('data-role');
            const status = row.getAttribute('data-status');

            const matchesSearch = name.includes(searchTerm) || email.includes(searchTerm);
            const matchesRole = !roleValue || role === roleValue;
            const matchesStatus = !statusValue || status === statusValue;

            return matchesSearch && matchesRole && matchesStatus;
        });

        // Update total items count
        totalItems.textContent = filteredRows.length;

        // Reset to first page when filtering
        currentPage = 1;
        updateTable();
        setupPagination();
    }

    // Update table display
    function updateTable() {
        const start = (currentPage - 1) * rowsPerPage;
        const end = start + rowsPerPage;

        // Hide all rows first
        document.querySelectorAll('.user-row').forEach(row => {
            row.style.display = 'none';
        });

        // Show only the rows for the current page
        filteredRows.slice(start, end).forEach(row => {
            row.style.display = '';
        });

        // Update showing from/to
        showingFrom.textContent = start + 1;
        showingTo.textContent = Math.min(end, filteredRows.length);
    }

    // Setup pagination
    function setupPagination() {
        const pageCount = Math.ceil(filteredRows.length / rowsPerPage);
        paginationNumbers.innerHTML = '';

        // Always show first page
        if (pageCount > 0) {
            addPageButton(1);
        }

        // Show current page and nearby pages
        const startPage = Math.max(2, currentPage - 1);
        const endPage = Math.min(pageCount - 1, currentPage + 1);

        if (startPage > 2) {
            paginationNumbers.innerHTML += '<span class="px-3 py-1">...</span>';
        }

        for (let i = startPage; i <= endPage; i++) {
            addPageButton(i);
        }

        if (endPage < pageCount - 1) {
            paginationNumbers.innerHTML += '<span class="px-3 py-1">...</span>';
        }

        // Always show last page if different from first
        if (pageCount > 1) {
            addPageButton(pageCount);
        }

        updatePaginationButtons();
    }

    function addPageButton(pageNumber) {
        const pageButton = document.createElement('button');
        pageButton.className = `px-3 py-1 border text-sm rounded-md ${pageNumber === currentPage ? 'border-blue-500 text-blue-600 dark:text-blue-400 bg-blue-50 dark:bg-blue-900' : 'border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700'}`;
        pageButton.textContent = pageNumber;
        pageButton.addEventListener('click', () => {
            currentPage = pageNumber;
            updateTable();
            setupPagination();
        });
        paginationNumbers.appendChild(pageButton);
    }

    function updatePaginationButtons() {
        const pageCount = Math.ceil(filteredRows.length / rowsPerPage);

        prevButton.disabled = currentPage === 1;
        nextButton.disabled = currentPage === pageCount || pageCount === 0;
    }

    // Event listeners for pagination
    prevButton.addEventListener('click', () => {
        if (currentPage > 1) {
            currentPage--;
            updateTable();
            setupPagination();
        }
    });

    nextButton.addEventListener('click', () => {
        const pageCount = Math.ceil(filteredRows.length / rowsPerPage);
        if (currentPage < pageCount) {
            currentPage++;
            updateTable();
            setupPagination();
        }
    });

    // Event listeners for filters
    searchInput.addEventListener('input', filterUsers);
    roleFilter.addEventListener('change', filterUsers);
    statusFilter.addEventListener('change', filterUsers);

    // Bulk actions
    const bulkActionsContainer = document.getElementById('bulkActionsContainer');
    const bulkActionsBtn = document.getElementById('bulkActionsBtn');
    const bulkActionDropdown = document.getElementById('bulkActionDropdown');
    const selectAllCheckbox = document.getElementById('selectAll');
    const userCheckboxes = document.querySelectorAll('.user-checkbox');
    const selectedCountSpan = document.getElementById('selectedCount');

    // Toggle dropdown
    bulkActionsBtn.addEventListener('click', function (e) {
        e.stopPropagation();
        bulkActionDropdown.classList.toggle('hidden');
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', function () {
        bulkActionDropdown.classList.add('hidden');
    });

    // Update selected count
    function updateSelectedCount() {
        const selectedCount = document.querySelectorAll('.user-checkbox:checked').length;
        selectedCountSpan.textContent = selectedCount;

        if (selectedCount > 0) {
            bulkActionsContainer.classList.remove('hidden');
        } else {
            bulkActionsContainer.classList.add('hidden');
            bulkActionDropdown.classList.add('hidden');
        }
    }

    // Select all functionality
    selectAllCheckbox.addEventListener('change', function () {
        userCheckboxes.forEach(checkbox => {
            checkbox.checked = this.checked;
        });
        updateSelectedCount();
    });

    // Individual checkbox functionality
    userCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function () {
            selectAllCheckbox.checked = [...userCheckboxes].every(cb => cb.checked);
            updateSelectedCount();
        });
    });

    // Bulk delete
    document.getElementById('bulkDeleteBtn').addEventListener('click', function () {
        const selectedIds = [...document.querySelectorAll('.user-checkbox:checked')]
            .map(checkbox => checkbox.closest('tr').dataset.userid);

        if (selectedIds.length === 0) return;

        const selectedNames = [...document.querySelectorAll('.user-checkbox:checked')]
            .map(checkbox => {
                const row = checkbox.closest('tr');
                return row.querySelector('td:nth-child(2)').textContent.trim();
            });

        let messageHtml;
        if (selectedNames.length === 1) {
            messageHtml = `
            <div class="swal-custom-container">
                <div class="swal-icon-container">
                    <i class="fas fa-trash-alt swal-trash-icon"></i>
                </div>
                <h3 class="swal-title">⚠️ تأكيد الحذف</h3>
                <div class="swal-content">
                    <p class="swal-text">
                        هل أنت متأكد أنك تريد حذف
                        <strong class="swal-highlight">${selectedNames[0]}</strong>؟
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
        } else {
            messageHtml = `
            <div class="swal-custom-container">
                <div class="swal-icon-container">
                    <i class="fas fa-trash-alt swal-trash-icon"></i>
                </div>
                <h3 class="swal-title">⚠️ تأكيد الحذف</h3>
                <div class="swal-content">
                    <p class="swal-text">
                        هل أنت متأكد أنك تريد حذف ${selectedNames.length} مستخدمين؟
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
        }

        Swal.fire({
            html: messageHtml,
            showCancelButton: true,
            confirmButtonText: '<i class="fas fa-check-circle mr-1"></i> نعم، احذف',
            cancelButtonText: '<i class="fas fa-times-circle mr-1"></i> إلغاء',
            buttonsStyling: false,
            showClass: {
                popup: 'animate__animated animate__fadeInDown'
            },
            hideClass: {
                popup: 'animate__animated animate__fadeOutUp'
            },
            customClass: {
                popup: 'swal-no-border',
                actions: 'swal-actions',
                confirmButton: 'swal-confirm-btn',
                cancelButton: 'swal-cancel-btn'
            },
            focusConfirm: false,
            focusCancel: false
        }).then((result) => {
            if (result.isConfirmed) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '/Admin/User/DeleteUsers';

                const token = document.querySelector('input[name="__RequestVerificationToken"]').value;
                const tokenInput = document.createElement('input');
                tokenInput.type = 'hidden';
                tokenInput.name = '__RequestVerificationToken';
                tokenInput.value = token;
                form.appendChild(tokenInput);

                selectedIds.forEach(id => {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'userIds';
                    input.value = id;
                    form.appendChild(input);
                });

                document.body.appendChild(form);
                form.submit();
            }
        });
    });

    // Edit user modal
    const editUserModal = document.getElementById('editUserModal');
    const editUserForm = document.getElementById('editUserForm');
    const editUserId = document.getElementById('editUserId');
    const editFullName = document.getElementById('editFullName');
    const editEmail = document.getElementById('editEmail');
    const editRole = document.getElementById('editRole');
    const saveEditBtn = document.getElementById('saveEditBtn');
    const cancelEditBtn = document.getElementById('cancelEditBtn');

    // Open edit modal
    document.querySelectorAll('.edit-btn').forEach(btn => {
        btn.addEventListener('click', function () {
            const userId = this.dataset.userid;
            const row = this.closest('tr');
            const name = row.querySelector('td:nth-child(2)').textContent.trim();
            const email = row.querySelector('td:nth-child(3)').textContent.trim();
            const role = row.getAttribute('data-role');

            editUserId.value = userId;
            editFullName.value = name;
            editEmail.value = email;
            editRole.value = role;

            editUserModal.classList.remove('hidden');
        });
    });

    // Close edit modal
    cancelEditBtn.addEventListener('click', function () {
        editUserModal.classList.add('hidden');
    });

    // Save edit - Now submits the form properly
    saveEditBtn.addEventListener('click', function () {
        // Validate form
        if (!editFullName.value || !editRole.value) {
            Swal.fire({
                title: 'خطأ',
                text: 'الرجاء تعبئة جميع الحقول المطلوبة',
                icon: 'error',
                confirmButtonColor: '#dc2626'
            });
            return;
        }

        // Submit the form
        editUserForm.submit();
    });

    // Close modal when clicking outside
    editUserModal.addEventListener('click', function (e) {
        if (e.target === editUserModal) {
            editUserModal.classList.add('hidden');
        }
    });
});


// Fancy delete function
function showFancyDelete(userId, userName) {
    Swal.fire({
        html: `
            <div class="swal-custom-container">
                <div class="swal-icon-container">
                    <i class="fas fa-trash-alt swal-trash-icon"></i>
                </div>
                <h3 class="swal-title">⚠️ تأكيد الحذف</h3>
                <div class="swal-content">
                    <p class="swal-text">
                        هل أنت متأكد أنك تريد حذف
                        <strong class="swal-highlight">${userName}</strong>؟
                    </p>
                    <div class="swal-warning">
                        <i class="fas fa-exclamation-circle swal-warning-icon"></i>
                        <span class="swal-warning-text">
                            لا يمكن التراجع عن هذا الحذف، سيتم حذف البيانات نهائيًا.
                        </span>
                    </div>
                </div>
            </div>
        `,
        showCancelButton: true,
        confirmButtonText: '<i class="fas fa-check-circle mr-1"></i> نعم، احذف',
        cancelButtonText: '<i class="fas fa-times-circle mr-1"></i> إلغاء',
        buttonsStyling: false,
        showClass: {
            popup: 'animate__animated animate__fadeInDown'
        },
        hideClass: {
            popup: 'animate__animated animate__fadeOutUp'
        },
        customClass: {
            popup: 'swal-no-border',
            actions: 'swal-actions',
            confirmButton: 'swal-confirm-btn',
            cancelButton: 'swal-cancel-btn'
        },
        focusConfirm: false,
        focusCancel: false
    }).then((result) => {
        if (result.isConfirmed) {
            fetch(`/Admin/User/Delete/${userId}`, {
                method: 'POST',
                headers: {
                    'RequestVerificationToken': document.querySelector('input[name="__RequestVerificationToken"]').value
                }
            }).then(response => {
                if (response.ok) {
                    location.reload();
                } else {
                    Swal.fire({
                        title: 'حدث خطأ!',
                        text: 'تعذر حذف المستخدم. حاول مرة أخرى.',
                        icon: 'error',
                        confirmButtonColor: '#dc2626'
                    });
                }
            });
        }
    });
}

// Lock User Functionality - Updated Version
document.addEventListener('DOMContentLoaded', function () {
    const lockModal = document.getElementById('lockUserModal');
    const lockUserIdInput = document.getElementById('lockUserId');
    const lockMinutesSelect = document.getElementById('lockMinutes');
    const confirmLockBtn = document.getElementById('confirmLockBtn');
    const cancelLockBtn = document.getElementById('cancelLockBtn');

    // Improved showLockModal function
    window.showLockModal = function (userId) {
        lockUserIdInput.value = userId;
        lockModal.classList.remove('hidden');
        lockMinutesSelect.value = '30'; // Default value
    };

    document.querySelector('.bulk-action-option:nth-child(2)')?.addEventListener('click', function () {
        const selectedIds = Array.from(document.querySelectorAll('.user-checkbox:checked'))
            .map(checkbox => checkbox.closest('tr').dataset.userid);

        if (selectedIds.length === 0) {
            Swal.fire({
                title: 'تحذير',
                text: 'لم يتم تحديد أي مستخدمين',
                icon: 'warning',
                confirmButtonColor: '#d33'
            });
            return;
        }

        showLockModal(selectedIds.join(','));
    });

    // Handle individual lock/unlock buttons
    document.querySelectorAll('.ban-btn').forEach(btn => {
        btn.addEventListener('click', function () {
            const userId = this.dataset.userid;
            const isLocked = this.dataset.islocked === 'true';

            if (isLocked) {
                // Unlock user - سيتم استخدام دالة unlockUsers مباشرة
                unlockUsers([userId]);
            } else {
                // Show lock modal
                showLockModal(userId);
            }
        });
    });

    // Confirm lock
    confirmLockBtn.addEventListener('click', function () {
        const userIds = lockUserIdInput.value;
        const minutes = lockMinutesSelect.value;

        if (!userIds || !minutes) {
            Swal.fire({
                title: 'خطأ',
                text: 'الرجاء تحديد مدة الحظر',
                icon: 'error',
                confirmButtonColor: '#d33'
            });
            return;
        }

        const userIdsArray = userIds.split(',');
        lockUsers(userIdsArray, minutes);
        lockModal.classList.add('hidden');
    });

    // Cancel lock
    cancelLockBtn.addEventListener('click', function () {
        lockModal.classList.add('hidden');
    });

    // Lock user function
    function lockUsers(userIds, minutes) {
        const isBulk = userIds.length > 1;
        let messageHtml;

        if (isBulk) {
            messageHtml = `
            <div class="swal-custom-container">
                <div class="swal-icon-container">
                    <i class="fas fa-lock swal-lock-icon"></i>
                </div>
                <h3 class="swal-title">⚠️ تأكيد القفل</h3>
                <div class="swal-content">
                    <p class="swal-text">
                        هل أنت متأكد أنك تريد قفل ${userIds.length} مستخدمين لمدة ${minutes} دقيقة؟
                    </p>
                    <div class="swal-warning">
                        <i class="fas fa-exclamation-circle swal-warning-icon"></i>
                        <span class="swal-warning-text">
                            لن يتمكن المستخدمون من تسجيل الدخول خلال هذه الفترة.
                        </span>
                    </div>
                </div>
            </div>
        `;
        } else {
            messageHtml = `
            <div class="swal-custom-container">
                <div class="swal-icon-container">
                    <i class="fas fa-lock swal-lock-icon"></i>
                </div>
                <h3 class="swal-title">⚠️ تأكيد القفل</h3>
                <div class="swal-content">
                    <p class="swal-text">
                        هل أنت متأكد أنك تريد قفل المستخدم لمدة ${minutes} دقيقة؟
                    </p>
                    <div class="swal-warning">
                        <i class="fas fa-exclamation-circle swal-warning-icon"></i>
                        <span class="swal-warning-text">
                            لن يتمكن المستخدم من تسجيل الدخول خلال هذه الفترة.
                        </span>
                    </div>
                </div>
            </div>
        `;
        }

        Swal.fire({
            html: messageHtml,
            showCancelButton: true,
            confirmButtonText: '<i class="fas fa-check-circle mr-1"></i> نعم، أقفل',
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
                form.action = '/Admin/User/LockUsers';

                const token = document.querySelector('input[name="__RequestVerificationToken"]').value;
                const tokenInput = document.createElement('input');
                tokenInput.type = 'hidden';
                tokenInput.name = '__RequestVerificationToken';
                tokenInput.value = token;
                form.appendChild(tokenInput);

                userIds.forEach(id => {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'userIds';
                    input.value = id;
                    form.appendChild(input);
                });

                const minutesInput = document.createElement('input');
                minutesInput.type = 'hidden';
                minutesInput.name = 'minutes';
                minutesInput.value = minutes;
                form.appendChild(minutesInput);

                document.body.appendChild(form);
                form.submit();
            }
        });
    }

    // Unlock user function
    function unlockUsers(userIds) {
        const isBulk = userIds.length > 1;
        let messageHtml;

        if (isBulk) {
            messageHtml = `
            <div class="swal-custom-container">
                <div class="swal-icon-container">
                    <i class="fas fa-unlock swal-unlock-icon"></i>
                </div>
                <h3 class="swal-title">⚠️ تأكيد فتح القفل</h3>
                <div class="swal-content">
                    <p class="swal-text">
                        هل أنت متأكد أنك تريد فتح قفل ${userIds.length} مستخدمين؟
                    </p>
                    <div class="swal-warning">
                        <i class="fas fa-exclamation-circle swal-warning-icon"></i>
                        <span class="swal-warning-text">
                            سيتمكن المستخدمون من تسجيل الدخول فوراً بعد التأكيد.
                        </span>
                    </div>
                </div>
            </div>
        `;
        } else {
            messageHtml = `
            <div class="swal-custom-container">
                <div class="swal-icon-container">
                    <i class="fas fa-unlock swal-unlock-icon"></i>
                </div>
                <h3 class="swal-title">⚠️ تأكيد فتح القفل</h3>
                <div class="swal-content">
                    <p class="swal-text">
                        هل أنت متأكد أنك تريد فتح قفل هذا المستخدم؟
                    </p>
                    <div class="swal-warning">
                        <i class="fas fa-exclamation-circle swal-warning-icon"></i>
                        <span class="swal-warning-text">
                            سيتمكن المستخدم من تسجيل الدخول فوراً بعد التأكيد.
                        </span>
                    </div>
                </div>
            </div>
        `;
        }

        Swal.fire({
            html: messageHtml,
            showCancelButton: true,
            confirmButtonText: '<i class="fas fa-check-circle mr-1"></i> نعم، أفتح القفل',
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
                form.action = '/Admin/User/UnlockUsers';

                const token = document.querySelector('input[name="__RequestVerificationToken"]').value;
                const tokenInput = document.createElement('input');
                tokenInput.type = 'hidden';
                tokenInput.name = '__RequestVerificationToken';
                tokenInput.value = token;
                form.appendChild(tokenInput);

                userIds.forEach(id => {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'userIds';
                    input.value = id;
                    form.appendChild(input);
                });

                document.body.appendChild(form);
                form.submit();
            }
        });
    }
});