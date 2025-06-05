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

document.addEventListener('DOMContentLoaded', function () {
    // Search and filter
    const searchInput = document.getElementById('searchInput');
    const roleFilter = document.getElementById('roleFilter');
    const statusFilter = document.getElementById('statusFilter');
    const userRows = document.querySelectorAll('.user-row');

    function filterUsers() {
        const searchTerm = searchInput.value.toLowerCase();
        const roleValue = roleFilter.value;
        const statusValue = statusFilter.value;

        userRows.forEach(row => {
            const name = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
            const email = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
            const role = row.getAttribute('data-role');
            const status = row.getAttribute('data-status');

            const matchesSearch = name.includes(searchTerm) || email.includes(searchTerm);
            const matchesRole = !roleValue || role === roleValue;
            const matchesStatus = !statusValue || status === statusValue;

            row.style.display = matchesSearch && matchesRole && matchesStatus ? '' : 'none';
        });
    }

    searchInput.addEventListener('input', filterUsers);
    roleFilter.addEventListener('change', filterUsers);
    statusFilter.addEventListener('change', filterUsers);

    // Pagination
    const rowsPerPage = 10;
    let currentPage = 1;
    const paginationNumbers = document.getElementById('paginationNumbers');
    const prevButton = document.getElementById('prevPage');
    const nextButton = document.getElementById('nextPage');

    function setupPagination() {
        const visibleRows = Array.from(userRows).filter(row => row.style.display !== 'none');
        const pageCount = Math.ceil(visibleRows.length / rowsPerPage);

        paginationNumbers.innerHTML = '';

        for (let i = 1; i <= pageCount; i++) {
            const pageButton = document.createElement('button');
            pageButton.className = `px-4 py-2 border ${i === currentPage ? 'border-blue-500 text-blue-600 dark:text-blue-400 bg-blue-50 dark:bg-blue-900' : 'border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700'} text-sm font-medium rounded-md`;
            pageButton.textContent = i;
            pageButton.addEventListener('click', () => {
                currentPage = i;
                updateTable();
                updatePaginationButtons();
            });
            paginationNumbers.appendChild(pageButton);
        }

        updatePaginationButtons();
    }

    function updateTable() {
        const visibleRows = Array.from(userRows).filter(row => row.style.display !== 'none');
        const start = (currentPage - 1) * rowsPerPage;
        const end = start + rowsPerPage;

        userRows.forEach(row => {
            if (row.style.display !== 'none') {
                const index = visibleRows.indexOf(row);
                row.style.display = index >= start && index < end ? '' : 'none';
            }
        });
    }

    function updatePaginationButtons() {
        const visibleRows = Array.from(userRows).filter(row => row.style.display !== 'none');
        const pageCount = Math.ceil(visibleRows.length / rowsPerPage);

        prevButton.disabled = currentPage === 1;
        nextButton.disabled = currentPage === pageCount || pageCount === 0;
    }

    prevButton.addEventListener('click', () => {
        if (currentPage > 1) {
            currentPage--;
            updateTable();
            updatePaginationButtons();
        }
    });

    nextButton.addEventListener('click', () => {
        const visibleRows = Array.from(userRows).filter(row => row.style.display !== 'none');
        const pageCount = Math.ceil(visibleRows.length / rowsPerPage);

        if (currentPage < pageCount) {
            currentPage++;
            updateTable();
            updatePaginationButtons();
        }
    });

    searchInput.addEventListener('input', () => {
        currentPage = 1;
        filterUsers();
        setupPagination();
        updateTable();
    });

    roleFilter.addEventListener('change', () => {
        currentPage = 1;
        filterUsers();
        setupPagination();
        updateTable();
    });

    statusFilter.addEventListener('change', () => {
        currentPage = 1;
        filterUsers();
        setupPagination();
        updateTable();
    });

    document.getElementById('selectAll').addEventListener('change', function () {
        const checkboxes = document.querySelectorAll('.user-checkbox');
        checkboxes.forEach(checkbox => {
            checkbox.checked = this.checked;
        });
    });

    // Bulk Actions Elements
    const bulkActionsContainer = document.getElementById('bulkActionsContainer');
    const bulkActionsBtn = document.getElementById('bulkActionsBtn');
    const bulkActionDropdown = document.getElementById('bulkActionDropdown');
    const selectAllCheckbox = document.getElementById('selectAll');
    const userCheckboxes = document.querySelectorAll('.user-checkbox');
    const selectedCountSpan = document.getElementById('selectedCount');

    // Toggle dropdown
    bulkActionsBtn.addEventListener('click', function (e) {
        e.stopPropagation();
        bulkActionDropdown.classList.toggle('show');
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', function () {
        bulkActionDropdown.classList.remove('show');
    });

    // Update selected count and show/hide bulk actions
    function updateSelectedCount() {
        const selectedCount = document.querySelectorAll('.user-checkbox:checked').length;
        selectedCountSpan.textContent = selectedCount;

        if (selectedCount > 0) {
            bulkActionsContainer.classList.remove('hidden');
        } else {
            bulkActionsContainer.classList.add('hidden');
            bulkActionDropdown.classList.remove('show');
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

    // Bulk delete functionality
    document.getElementById('bulkDeleteBtn').addEventListener('click', function () {
        const selectedIds = [...document.querySelectorAll('.user-checkbox:checked')]
            .map(checkbox => checkbox.closest('tr').dataset.userId);

        if (selectedIds.length === 0) return;

        // Here you would implement your bulk delete logic
        console.log('Users to delete:', selectedIds);
        // Typically you would send an AJAX request here
    });

    filterUsers();
    setupPagination();
    updateTable();
});