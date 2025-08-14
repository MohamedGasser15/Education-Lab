
//let sectionCounter = 0;
//let editSectionCounter = 0;

//async function loadCategories(selectElementId) {
//    try {
//        const response = await fetch('/Admin/Course/GetCategories');
//        if (response.ok) {
//            const data = await response.json();
//            const selectElement = document.getElementById(selectElementId);
//            selectElement.innerHTML = '<option value="">اختر تصنيفًا</option>';

//            data.forEach(category => {
//                const option = document.createElement('option');
//                option.value = category.id;
//                option.textContent = category.name;
//                selectElement.appendChild(option);
//            });
//        } else {
//            console.error('Failed to load categories:', response.status);
//        }
//    } catch (error) {
//        console.error('Error fetching categories:', error);
//    }
//}

//function setupImagePreview(inputId, previewId, uploadAreaId) {
//    const input = document.getElementById(inputId);
//    const preview = document.getElementById(previewId);
//    const uploadArea = document.getElementById(uploadAreaId);

//    if (input && preview && uploadArea) {
//        input.addEventListener('change', function(e) {
//            const file = e.target.files[0];
//            if (file) {
//                const reader = new FileReader();
//                reader.onload = function(e) {
//                    preview.src = e.target.result;
//                    preview.style.display = 'block';
//                    uploadArea.style.display = 'none';
//                };
//                reader.readAsDataURL(file);
//            }
//        });
//    }
//}

//function setupSectionManagement(containerId, addButtonId, prefix) {
//    const container = document.getElementById(containerId);
//    const addButton = document.getElementById(addButtonId);

//    if (addButton) {
//        addButton.addEventListener('click', function() {
//            const sectionId = `${prefix}-section-${Date.now()}`;

//            const sectionHTML = `
//                <div class="section-container" data-section-id="${sectionId}">
//                    <div class="flex justify-between items-center mb-3">
//                        <input type="text" name="${prefix}-section-title" placeholder="اسم القسم"
//                               class="font-medium px-3 py-1 border-b border-gray-300 dark:border-gray-600 focus:outline-none focus:border-blue-500 dark:bg-gray-700 dark:text-white w-full">
//                        <button type="button" class="text-red-500 hover:text-red-700 delete-section" data-section-id="${sectionId}">
//                            <i class="fas fa-trash"></i>
//                        </button>
//                    </div>
//                    <div class="lessons-container space-y-2" id="${prefix}-lessons-${sectionId}"></div>
//                    <button type="button" class="mt-2 text-sm text-blue-600 dark:text-blue-400 hover:underline add-lesson" data-section-id="${sectionId}" data-prefix="${prefix}">
//                        <i class="fas fa-plus mr-1"></i> إضافة درس
//                    </button>
//                </div>
//            `;

//            container.insertAdjacentHTML('beforeend', sectionHTML);
//        });
//    }

//    container.addEventListener('click', function(e) {
//        if (e.target.classList.contains('add-lesson') || e.target.closest('.add-lesson')) {
//            const button = e.target.classList.contains('add-lesson') ? e.target : e.target.closest('.add-lesson');
//            const sectionId = button.getAttribute('data-section-id');
//            const prefix = button.getAttribute('data-prefix');
//            const lessonsContainer = document.getElementById(`${prefix}-lessons-${sectionId}`);
//            const lessonId = `${prefix}-lesson-${Date.now()}`;

//            const lessonHTML = `
//                <div class="lesson-item" data-lesson-id="${lessonId}">
//                    <div class="flex-1 flex items-center space-x-3 space-x-reverse">
//                        <i class="fas fa-grip-vertical text-gray-400 dark:text-gray-500 cursor-move handle"></i>
//                        <input type="text" name="${prefix}-lesson-title" placeholder="عنوان الدرس"
//                               class="flex-1 px-2 py-1 border-b border-gray-300 dark:border-gray-600 focus:outline-none focus:border-blue-500 dark:bg-gray-700 dark:text-white">
//                    </div>
//                    <div class="flex items-center space-x-2 space-x-reverse">
//                        <select name="${prefix}-lesson-type" class="text-sm px-2 py-1 border border-gray-300 dark:border-gray-600 rounded focus:outline-none focus:ring-1 focus:ring-blue-500 dark:bg-gray-700 dark:text-white">
//                            <option value="video">فيديو</option>
//                            <option value="article">مقال</option>
//                            <option value="quiz">اختبار</option>
//                        </select>
//                        <input type="file" name="${prefix}-video" accept="video/*" class="hidden video-upload">
//                        <button type="button" class="text-blue-500 hover:text-blue-700 upload-video" data-lesson-id="${lessonId}">
//                            <i class="fas fa-upload"></i>
//                        </button>
//                        <button type="button" class="text-red-500 hover:text-red-700 delete-lesson" data-lesson-id="${lessonId}">
//                            <i class="fas fa-trash"></i>
//                        </button>
//                    </div>
//                </div>
//            `;

//            lessonsContainer.insertAdjacentHTML('beforeend', lessonHTML);
//        }

//        if (e.target.classList.contains('delete-section') || e.target.closest('.delete-section')) {
//            const button = e.target.classList.contains('delete-section') ? e.target : e.target.closest('.delete-section');
//            const sectionId = button.getAttribute('data-section-id');
//            document.querySelector(`[data-section-id="${sectionId}"]`).remove();
//        }

//        if (e.target.classList.contains('delete-lesson') || e.target.closest('.delete-lesson')) {
//            const button = e.target.classList.contains('delete-lesson') ? e.target : e.target.closest('.delete-lesson');
//            const lessonId = button.getAttribute('data-lesson-id');
//            document.querySelector(`[data-lesson-id="${lessonId}"]`).remove();
//        }

//        if (e.target.classList.contains('upload-video') || e.target.closest('.upload-video')) {
//            const button = e.target.classList.contains('upload-video') ? e.target : e.target.closest('.upload-video');
//            const lessonId = button.getAttribute('data-lesson-id');
//            const videoInput = document.querySelector(`[data-lesson-id="${lessonId}"] .video-upload`);
//            videoInput.click();
//        }
//    });

//    if (container) {
//        new Sortable(container, {
//            handle: '.handle',
//            animation: 150,
//            ghostClass: 'sortable-ghost'
//        });
//    }
//}

//function setupModal(modalId, openButtons, closeButton) {
//    const modal = document.getElementById(modalId);
//    if (!modal) return;

//    const modalOverlay = modal.querySelector('.modal-overlay');
//    const modalContainer = modal.querySelector('.modal-container');

//    // فتح المودال
//    if (openButtons) {
//        openButtons.forEach(button => {
//            if (button) {
//                button.addEventListener('click', function() {
//                    modal.style.display = 'block';
//                    if (modalContainer) modalContainer.style.display = 'block';
//                    document.body.style.overflow = 'hidden';
//                });
//            }
//        });
//    }

//    if (closeButton) {
//        closeButton.addEventListener('click', function() {
//            modal.style.display = 'none';
//            if (modalContainer) modalContainer.style.display = 'none';
//            document.body.style.overflow = 'auto';
//        });
//    }

//    if (modalOverlay) {
//        modalOverlay.addEventListener('click', function() {
//            modal.style.display = 'none';
//            if (modalContainer) modalContainer.style.display = 'none';
//            document.body.style.overflow = 'auto';
//        });
//    }
//}

//    // Update course functionality
//    async function fetchCourseForEdit(courseId) {
//        try {
//            const response = await fetch(`/Admin/Course/Edit/${courseId}`);
//            if (!response.ok) throw new Error('Network response was not ok');

//            const data = await response.json();
//            if (!data.success) throw new Error(data.message || 'Failed to fetch course data');

//            // Fill the form with the received data
//            fillEditForm(data.course);

//        } catch (error) {
//            console.error('Error fetching course for edit:', error);
//            Swal.fire({
//                title: 'خطأ!',
//                text: 'حدث خطأ أثناء جلب بيانات الكورس للتعديل: ' + error.message,
//                icon: 'error'
//            });
//        }
//    }

//    function fillEditForm(course) {
//        document.getElementById('editCourseId').value = course.id;
//        document.getElementById('editTitle').value = course.title;
//        document.getElementById('editShortDescription').value = course.shortDescription;
//        document.getElementById('editDescription').value = course.description;
//        document.getElementById('editPrice').value = course.price;
//        document.getElementById('editDiscount').value = course.discount || 0;
//        document.getElementById('editLevel').value = course.level;
//        document.getElementById('editLanguage').value = course.language;
//        document.getElementById('editDuration').value = course.duration;
//        document.getElementById('editLectures').value = course.lectures;
//        document.getElementById('editCertificate').checked = course.hasCertificate;
//        document.getElementById('editRequirements').value = course.requirements?.join('\n') || '';
//        document.getElementById('editLearnings').value = course.learnings?.join('\n') || '';
//        document.getElementById('editTargetAudience').value = course.targetAudience || '';

//        // Set category
//        const categorySelect = document.getElementById('editCategory');
//        if (categorySelect) {
//            categorySelect.value = course.categoryId;
//        }

//        // Set image preview if exists
//        if (course.thumbnailUrl) {
//            const preview = document.getElementById('editPreviewImage');
//            preview.src = course.thumbnailUrl;
//            preview.style.display = 'block';
//            document.getElementById('editUploadArea').style.display = 'none';
//        }

//        // Fill sections
//        const sectionsContainer = document.getElementById('editCourseSectionsContainer');
//        sectionsContainer.innerHTML = '';

//        if (course.sections && course.sections.length) {
//            course.sections.forEach(section => {
//                const sectionId = `edit-section-${Date.now()}`;
//                const sectionHTML = `
//                    <div class="section-container" data-section-id="${sectionId}">
//                        <div class="flex justify-between items-center mb-3">
//                            <input type="text" name="edit-section-title" placeholder="اسم القسم"
//                                   value="${section.title}"
//                                   class="font-medium px-3 py-1 border-b border-gray-300 dark:border-gray-600 focus:outline-none focus:border-blue-500 dark:bg-gray-700 dark:text-white w-full">
//                            <button type="button" class="text-red-500 hover:text-red-700 delete-section" data-section-id="${sectionId}">
//                                <i class="fas fa-trash"></i>
//                            </button>
//                        </div>
//                        <div class="lessons-container space-y-2" id="edit-lessons-${sectionId}"></div>
//                        <button type="button" class="mt-2 text-sm text-blue-600 dark:text-blue-400 hover:underline add-lesson" data-section-id="${sectionId}" data-prefix="edit">
//                            <i class="fas fa-plus mr-1"></i> إضافة درس
//                        </button>
//                    </div>
//                `;
//                sectionsContainer.insertAdjacentHTML('beforeend', sectionHTML);

//                // Fill lessons
//                const lessonsContainer = document.getElementById(`edit-lessons-${sectionId}`);
//                if (section.lectures && section.lectures.length) {
//                    section.lectures.forEach(lecture => {
//                        const lessonId = `edit-lesson-${Date.now()}`;
//                        const lessonHTML = `
//                            <div class="lesson-item" data-lesson-id="${lessonId}">
//                                <div class="flex-1 flex items-center space-x-3 space-x-reverse">
//                                    <i class="fas fa-grip-vertical text-gray-400 dark:text-gray-500 cursor-move handle"></i>
//                                    <input type="text" name="edit-lesson-title" placeholder="عنوان الدرس"
//                                           value="${lecture.title}"
//                                           class="flex-1 px-2 py-1 border-b border-gray-300 dark:border-gray-600 focus:outline-none focus:border-blue-500 dark:bg-gray-700 dark:text-white">
//                                </div>
//                                <div class="flex items-center space-x-2 space-x-reverse">
//                                    <select name="edit-lesson-type" class="text-sm px-2 py-1 border border-gray-300 dark:border-gray-600 rounded focus:outline-none focus:ring-1 focus:ring-blue-500 dark:bg-gray-700 dark:text-white">
//                                        <option value="video" ${lecture.type === 'video' ? 'selected' : ''}>فيديو</option>
//                                        <option value="article" ${lecture.type === 'article' ? 'selected' : ''}>مقال</option>
//                                        <option value="quiz" ${lecture.type === 'quiz' ? 'selected' : ''}>اختبار</option>
//                                    </select>
//                                    <input type="file" name="edit-video" accept="video/*" class="hidden video-upload">
//                                    <button type="button" class="text-blue-500 hover:text-blue-700 upload-video" data-lesson-id="${lessonId}">
//                                        <i class="fas fa-upload"></i>
//                                    </button>
//                                    <button type="button" class="text-red-500 hover:text-red-700 delete-lesson" data-lesson-id="${lessonId}">
//                                        <i class="fas fa-trash"></i>
//                                    </button>
//                                </div>
//                            </div>
//                        `;
//                        lessonsContainer.insertAdjacentHTML('beforeend', lessonHTML);
//                    });
//                }
//            });
//        }

//        // Show the modal
//        document.getElementById('editCourseModal').style.display = 'block';
//        document.querySelector('#editCourseModal .modal-container').style.display = 'block';
//        document.body.style.overflow = 'hidden';
//    }
//    async function submitEditForm(formData) {
//        try {
//            const response = await fetch('/Admin/Course/Edit', {
//                method: 'POST',
//                body: formData,
//                headers: {
//                    'RequestVerificationToken': document.querySelector('input[name="__RequestVerificationToken"]').value
//                }
//            });

//            const data = await response.json();

//            if (data.success) {
//                Swal.fire({
//                    title: 'تم بنجاح!',
//                    text: data.message || 'تم تحديث الكورس بنجاح',
//                    icon: 'success'
//                }).then(() => {
//                    window.location.reload();
//                });
//            } else {
//                let errorMessage = data.message || 'حدث خطأ أثناء تحديث الكورس';
//                if (data.errors) {
//                    errorMessage += '<br>' + Object.values(data.errors).join('<br>');
//                }
//                Swal.fire({
//                    title: 'خطأ!',
//                    html: errorMessage,
//                    icon: 'error'
//                });
//            }
//        } catch (error) {
//            console.error('Error submitting form:', error);
//            Swal.fire({
//                title: 'خطأ!',
//                text: 'حدث خطأ أثناء محاولة تحديث الكورس',
//                icon: 'error'
//            });
//        }
//    }

//async function submitAddForm(formData) {
//    try {
//        const response = await fetch('/Admin/Course/CreateCourse', {
//            method: 'POST',
//            body: formData,
//            headers: {
//                'RequestVerificationToken': document.querySelector('input[name="__RequestVerificationToken"]').value
//            }
//        });

//        const data = await response.json();

//        if (data.success) {
//            Swal.fire({
//                title: 'تم بنجاح!',
//                text: data.message,
//                icon: 'success'
//            }).then(() => {
//                window.location.reload();
//            });
//        } else {
//            let errorMessage = data.message || 'حدث خطأ أثناء إنشاء الكورس';
//            if (data.errors) {
//                errorMessage += '<br>' + Object.values(data.errors).join('<br>');
//            }
//            Swal.fire({
//                title: 'خطأ!',
//                html: errorMessage,
//                icon: 'error'
//            });
//        }

//    } catch (error) {
//        console.error('Error submitting form:', error);
//        Swal.fire({
//            title: 'خطأ!',
//            text: 'حدث خطأ أثناء محاولة إنشاء الكورس',
//            icon: 'error'
//        });
//    }
//}


//async function fetchCourseDetails(courseId) {
//    try {

//        const mockData = {
//            id: courseId,
//            title: "كورس تطوير الويب المتقدم",
//            shortDescription: "هذا الكورس يغطي أهم تقنيات تطوير الويب الحديثة",
//            description: "في هذا الكورس سوف تتعلم أحدث تقنيات تطوير الويب بما في ذلك HTML5, CSS3, JavaScript, React, Node.js وغيرها من التقنيات الحديثة. الكورس مصمم للمبتدئين والمحترفين على حد سواء.",
//            instructorName: "أحمد محمد",
//            price: 499,
//            discount: 100,
//            level: "متوسط",
//            language: "العربية",
//            duration: 360,
//            hasCertificate: true,
//            thumbnailUrl: "https://via.placeholder.com/800x450",
//            sections: [
//                {
//                    title: "مقدمة في تطوير الويب",
//                    lectures: [
//                        { title: "مقدمة الكورس", duration: 15 },
//                        { title: "أدوات المطور", duration: 20 },
//                        { title: "أساسيات HTML", duration: 30 }
//                    ]
//                },
//                {
//                    title: "تصميم الواجهات",
//                    lectures: [
//                        { title: "أساسيات CSS", duration: 45 },
//                        { title: "التصميم المتجاوب", duration: 60 },
//                        { title: "Flexbox و Grid", duration: 50 }
//                    ]
//                },
//                {
//                    title: "البرمجة بلغة JavaScript",
//                    lectures: [
//                        { title: "أساسيات JavaScript", duration: 60 },
//                        { title: "الوظائف والكائنات", duration: 45 },
//                        { title: "البرمجة غير المتزامنة", duration: 50 }
//                    ]
//                }
//            ]
//        };

//        document.getElementById('modalCourseImage').src = mockData.thumbnailUrl;
//        document.getElementById('modalCourseTitle').textContent = mockData.title;
//        document.getElementById('modalCourseShortDesc').textContent = mockData.shortDescription;
//        document.getElementById('modalCourseFullDesc').textContent = mockData.description;
//        document.getElementById('modalCourseInstructor').textContent = mockData.instructorName;
//        document.getElementById('modalCoursePrice').textContent = `${mockData.price.toFixed(2)} ج.م`;
//        document.getElementById('modalCourseDiscount').textContent = mockData.discount > 0 ? `${mockData.discount.toFixed(2)} ج.م` : "لا يوجد خصم";
//        document.getElementById('modalCourseFinalPrice').textContent = `${(mockData.price - mockData.discount).toFixed(2)} ج.م`;
//        document.getElementById('modalCourseLevel').textContent = mockData.level;
//        document.getElementById('modalCourseLanguage').textContent = mockData.language === 'ar' ? 'العربية' : 'الإنجليزية';
//        document.getElementById('modalCourseDuration').textContent = `${Math.floor(mockData.duration / 60)} ساعة ${mockData.duration % 60} دقيقة`;
//        document.getElementById('modalCourseCertificate').textContent = mockData.hasCertificate ? 'نعم' : 'لا';

//        const sectionsContainer = document.getElementById('modalCourseSections');
//        sectionsContainer.innerHTML = '';

//        mockData.sections.forEach((section, index) => {
//            const sectionHtml = `
//                <div class="border border-gray-200 dark:border-gray-700 rounded-lg overflow-hidden">
//                    <div class="bg-gray-100 dark:bg-gray-700 px-4 py-3 flex items-center justify-between">
//                        <h5 class="font-medium text-gray-800 dark:text-white">
//                            <i class="fas fa-folder-open text-blue-500 mr-2"></i>
//                            ${section.title}
//                        </h5>
//                        <span class="text-xs bg-blue-100 dark:bg-blue-900 text-blue-800 dark:text-blue-200 px-2 py-1 rounded-full">
//                            ${section.lectures.length} دروس
//                        </span>
//                    </div>
//                    <div class="divide-y divide-gray-200 dark:divide-gray-700">
//                        ${section.lectures.map(lecture => `
//                            <div class="px-4 py-3 flex items-center justify-between">
//                                <div class="flex items-center">
//                                    <i class="fas fa-play-circle text-gray-400 dark:text-gray-500 mr-3"></i>
//                                    <span class="text-sm text-gray-800 dark:text-white">${lecture.title}</span>
//                                </div>
//                                <span class="text-xs text-gray-500 dark:text-gray-400">${lecture.duration} دقيقة</span>
//                            </div>
//                        `).join('')}
//                    </div>
//                </div>
//            `;

//            sectionsContainer.insertAdjacentHTML('beforeend', sectionHtml);
//        });

//        document.getElementById('courseDetailsModal').classList.remove('hidden');
//        document.body.style.overflow = 'hidden';

//    } catch (error) {
//        console.error('Error fetching course details:', error);
//        Swal.fire(
//            'خطأ!',
//            'حدث خطأ أثناء جلب تفاصيل الكورس.',
//            'error'
//        );
//    }
//}

//function closeDetailsModal() {
//    document.getElementById('courseDetailsModal').classList.add('hidden');
//    document.body.style.overflow = 'auto';
//}

//// Pagination functionality
//function setupPagination() {
//        const itemsPerPage = 10;
//        const tableRows = document.querySelectorAll('tbody tr[data-course-id]');
//        const paginationContainer = document.querySelector('.relative.z-0.inline-flex.rounded-lg.shadow-sm.-space-x-px');

//        if (!tableRows.length || !paginationContainer) return;

//        const totalPages = Math.ceil(tableRows.length / itemsPerPage);
//        let currentPage = 1;

//        function showPage(page) {
//            const startIndex = (page - 1) * itemsPerPage;
//            const endIndex = startIndex + itemsPerPage;

//            tableRows.forEach((row, index) => {
//                row.style.display = (index >= startIndex && index < endIndex) ? '' : 'none';
//            });

//            // Update active page indicator
//            document.querySelectorAll('.pagination-link').forEach(link => {
//                link.classList.toggle('bg-blue-50', link.textContent == page);
//                link.classList.toggle('border-blue-500', link.textContent == page);
//                link.classList.toggle('text-blue-600', link.textContent == page);
//                link.classList.toggle('dark:bg-blue-900', link.textContent == page);
//                link.classList.toggle('dark:text-blue-200', link.textContent == page);
//            });
//        }

//        // Create pagination links
//        if (totalPages > 1) {
//            paginationContainer.innerHTML = '';

//            // Previous button
//            const prevButton = document.createElement('a');
//            prevButton.href = '#';
//            prevButton.className = 'relative inline-flex items-center px-2 py-2 rounded-r-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-sm font-medium text-gray-500 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700';
//            prevButton.innerHTML = '<i class="fas fa-chevron-right"></i>';
//            prevButton.addEventListener('click', (e) => {
//                e.preventDefault();
//                if (currentPage > 1) {
//                    currentPage--;
//                    showPage(currentPage);
//                }
//            });
//            paginationContainer.appendChild(prevButton);

//            // Page numbers
//            for (let i = 1; i <= totalPages; i++) {
//                const pageLink = document.createElement('a');
//                pageLink.href = '#';
//                pageLink.className = `pagination-link relative inline-flex items-center px-4 py-2 border text-sm font-medium ${i === 1 ? 'bg-blue-50 dark:bg-blue-900 border-blue-500 text-blue-600 dark:text-blue-200' : 'bg-white dark:bg-gray-800 border-gray-300 dark:border-gray-600 text-gray-500 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700'}`;
//                pageLink.textContent = i;
//                pageLink.addEventListener('click', (e) => {
//                    e.preventDefault();
//                    currentPage = i;
//                    showPage(currentPage);
//                });
//                paginationContainer.appendChild(pageLink);
//            }

//            // Next button
//            const nextButton = document.createElement('a');
//            nextButton.href = '#';
//            nextButton.className = 'relative inline-flex items-center px-2 py-2 rounded-l-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-800 text-sm font-medium text-gray-500 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700';
//            nextButton.innerHTML = '<i class="fas fa-chevron-left"></i>';
//            nextButton.addEventListener('click', (e) => {
//                e.preventDefault();
//                if (currentPage < totalPages) {
//                    currentPage++;
//                    showPage(currentPage);
//                }
//            });
//            paginationContainer.appendChild(nextButton);
//        }

//        // Show first page initially
//        showPage(1);
//    }

//// Select all and bulk actions functionality
//    function setupBulkActions() {
//        // Add checkbox column to header
//        const tableHeader = document.querySelector('thead tr');
//        if (tableHeader) {
//            const checkboxHeader = document.createElement('th');
//            checkboxHeader.className = 'px-6 py-4 text-right font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider';
//            checkboxHeader.innerHTML = `
//                <div class="flex items-center justify-center">
//                    <input type="checkbox" id="selectAll" class="bulk-checkbox h-4 w-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600">
//                </div>
//            `;
//            tableHeader.insertBefore(checkboxHeader, tableHeader.firstChild);
//        }

//        // Add checkbox to each row
//        const rows = document.querySelectorAll('tbody tr[data-course-id]');
//        rows.forEach(row => {
//            const checkboxCell = document.createElement('td');
//            checkboxCell.className = 'px-6 py-4 whitespace-nowrap';
//            checkboxCell.innerHTML = `
//                <div class="flex items-center justify-center">
//                    <input type="checkbox" class="row-checkbox bulk-checkbox h-4 w-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600" data-id="${row.getAttribute('data-course-id')}">
//                </div>
//            `;
//            row.insertBefore(checkboxCell, row.firstChild);
//        });

//        // Select all functionality
//        document.getElementById('selectAll')?.addEventListener('change', function() {
//            const isChecked = this.checked;
//            document.querySelectorAll('.row-checkbox').forEach(checkbox => {
//                checkbox.checked = isChecked;
//            });
//            updateSelectedCount();
//        });

//        // Row checkbox functionality
//        document.querySelectorAll('.row-checkbox').forEach(checkbox => {
//            checkbox.addEventListener('change', function() {
//                updateSelectedCount();
//                const allChecked = document.querySelectorAll('.row-checkbox:checked').length;
//                const totalCheckboxes = document.querySelectorAll('.row-checkbox').length;
//                document.getElementById('selectAll').checked = allChecked === totalCheckboxes;
//            });
//        });

//        // Bulk action functionality
//        document.getElementById('applyBulkAction')?.addEventListener('click', function() {
//            const action = document.getElementById('bulkAction').value;
//            const selectedIds = Array.from(document.querySelectorAll('.row-checkbox:checked'))
//                .map(checkbox => checkbox.getAttribute('data-id'));

//            if (!action) {
//                Swal.fire({
//                    title: 'تحذير!',
//                    text: 'يرجى اختيار إجراء لتطبيقه',
//                    icon: 'warning'
//                });
//                return;
//            }

//            if (selectedIds.length === 0) {
//                Swal.fire({
//                    title: 'تحذير!',
//                    text: 'لم يتم تحديد أي عناصر',
//                    icon: 'warning'
//                });
//                return;
//            }

//            if (action === 'delete') {
//                showBulkDeleteConfirmation(selectedIds);
//            } else {
//                applyBulkAction(action, selectedIds);
//            }
//        });

//        function updateSelectedCount() {
//            const selectedCount = document.querySelectorAll('.row-checkbox:checked').length;
//            const countElement = document.getElementById('selectedCount');
//            const bulkContainer = document.getElementById('bulkActionsContainer');

//            if (countElement) countElement.textContent = selectedCount;

//            if (bulkContainer) {
//                bulkContainer.classList.toggle('hidden', selectedCount === 0);
//            }
//        }
//    }

//    function showBulkDeleteConfirmation(selectedIds) {
//        const messageHtml = `
//        <div class="swal-custom-container">
//            <div class="swal-icon-container">
//                <i class="fas fa-trash-alt swal-trash-icon"></i>
//            </div>
//            <h3 class="swal-title">⚠️ تأكيد الحذف</h3>
//            <div class="swal-content">
//                <p class="swal-text">
//                    هل أنت متأكد أنك تريد حذف ${selectedIds.length} كورسات؟
//                </p>
//                <div class="swal-warning">
//                    <i class="fas fa-exclamation-circle swal-warning-icon"></i>
//                    <span class="swal-warning-text">
//                        لا يمكن التراجع عن هذا الحذف، سيتم حذف البيانات نهائيًا.
//                    </span>
//                </div>
//            </div>
//        </div>
//        `;

//        Swal.fire({
//            html: messageHtml,
//            icon: 'warning',
//            showCancelButton: true,
//            confirmButtonText: 'نعم، احذف',
//            cancelButtonText: 'إلغاء',
//            confirmButtonColor: '#dc2626',
//            cancelButtonColor: '#e5e7eb',
//            customClass: {
//                container: 'swal-no-border',
//                confirmButton: 'swal-confirm-btn',
//                cancelButton: 'swal-cancel-btn'
//            },
//            reverseButtons: true
//        }).then((result) => {
//            if (result.isConfirmed) {
//                bulkDeleteCourses(selectedIds);
//            }
//        });
//    }

//    async function bulkDeleteCourses(ids) {
//        try {
//            const response = await fetch('/Admin/Course/BulkDelete', {
//                method: 'POST',
//                headers: {
//                    'Content-Type': 'application/json',
//                    'RequestVerificationToken': document.querySelector('input[name="__RequestVerificationToken"]').value
//                },
//                body: JSON.stringify({ ids })
//            });

//            const data = await response.json();

//            if (data.success) {
//                Swal.fire({
//                    title: 'تم بنجاح!',
//                    text: `تم حذف ${ids.length} كورسات بنجاح`,
//                    icon: 'success'
//                }).then(() => {
//                    window.location.reload();
//                });
//            } else {
//                Swal.fire({
//                    title: 'خطأ!',
//                    text: data.message || 'حدث خطأ أثناء الحذف الجماعي',
//                    icon: 'error'
//                });
//            }
//        } catch (error) {
//            console.error('Error:', error);
//            Swal.fire({
//                title: 'خطأ!',
//                text: 'حدث خطأ أثناء الحذف الجماعي',
//                icon: 'error'
//            });
//        }
//    }

//    async function applyBulkAction(action, ids) {
//        try {
//            const response = await fetch('/Admin/Course/BulkAction', {
//                method: 'POST',
//                headers: {
//                    'Content-Type': 'application/json',
//                    'RequestVerificationToken': document.querySelector('input[name="__RequestVerificationToken"]').value
//                },
//                body: JSON.stringify({ action, ids })
//            });

//            const data = await response.json();

//            if (data.success) {
//                Swal.fire({
//                    title: 'تم بنجاح!',
//                    text: `تم تطبيق الإجراء على ${ids.length} كورسات بنجاح`,
//                    icon: 'success'
//                }).then(() => {
//                    window.location.reload();
//                });
//            } else {
//                Swal.fire({
//                    title: 'خطأ!',
//                    text: data.message || 'حدث خطأ أثناء تطبيق الإجراء الجماعي',
//                    icon: 'error'
//                });
//            }
//        } catch (error) {
//            console.error('Error:', error);
//            Swal.fire({
//                title: 'خطأ!',
//                text: 'حدث خطأ أثناء تطبيق الإجراء الجماعي',
//                icon: 'error'
//            });
//        }
//    }

//// Custom delete confirmation modal
//function showDeleteConfirmation(courseId, courseName) {
//        let messageHtml;
//        if (courseName) {
//            messageHtml = `
//            <div class="swal-custom-container">
//                <div class="swal-icon-container">
//                    <i class="fas fa-trash-alt swal-trash-icon"></i>
//                </div>
//                <h3 class="swal-title">⚠️ تأكيد الحذف</h3>
//                <div class="swal-content">
//                    <p class="swal-text">
//                        هل أنت متأكد أنك تريد حذف
//                        <strong class="swal-highlight">${courseName}</strong>؟
//                    </p>
//                    <div class="swal-warning">
//                        <i class="fas fa-exclamation-circle swal-warning-icon"></i>
//                        <span class="swal-warning-text">
//                            لا يمكن التراجع عن هذا الحذف، سيتم حذف البيانات نهائيًا.
//                        </span>
//                    </div>
//                </div>
//            </div>
//            `;
//        } else {
//            messageHtml = `
//            <div class="swal-custom-container">
//                <div class="swal-icon-container">
//                    <i class="fas fa-trash-alt swal-trash-icon"></i>
//                </div>
//                <h3 class="swal-title">⚠️ تأكيد الحذف</h3>
//                <div class="swal-content">
//                    <p class="swal-text">
//                        هل أنت متأكد أنك تريد حذف الكورس المحدد؟
//                    </p>
//                    <div class="swal-warning">
//                        <i class="fas fa-exclamation-circle swal-warning-icon"></i>
//                        <span class="swal-warning-text">
//                            لا يمكن التراجع عن هذا الحذف، سيتم حذف البيانات نهائيًا.
//                        </span>
//                    </div>
//                </div>
//            </div>
//            `;
//        }

//        Swal.fire({
//            html: messageHtml,
//            icon: 'warning',
//            showCancelButton: true,
//            confirmButtonText: 'نعم، احذف',
//            cancelButtonText: 'إلغاء',
//            confirmButtonColor: '#dc2626',
//            cancelButtonColor: '#e5e7eb',
//            customClass: {
//                container: 'swal-no-border',
//                confirmButton: 'swal-confirm-btn',
//                cancelButton: 'swal-cancel-btn'
//            },
//            reverseButtons: true
//        }).then((result) => {
//            if (result.isConfirmed) {
//                deleteCourse(courseId);
//            }
//        });
//    }

//    async function deleteCourse(courseId) {
//        try {
//            const response = await fetch(`/Admin/Course/Delete/${courseId}`, {
//                method: 'POST',
//                headers: {
//                    'RequestVerificationToken': document.querySelector('input[name="__RequestVerificationToken"]').value,
//                    'Content-Type': 'application/json'
//                }
//            });

//            if (response.ok) {
//                Swal.fire({
//                    title: 'تم الحذف!',
//                    text: 'تم حذف الكورس بنجاح.',
//                    icon: 'success'
//                }).then(() => {
//                    window.location.reload();
//                });
//            } else {
//                const data = await response.json();
//                Swal.fire({
//                    title: 'خطأ!',
//                    text: data.message || 'حدث خطأ أثناء الحذف.',
//                    icon: 'error'
//                });
//            }
//        } catch (error) {
//            console.error('Error:', error);
//            Swal.fire({
//                title: 'خطأ!',
//                text: 'حدث خطأ أثناء الحذف.',
//                icon: 'error'
//            });
//        }
//    }

//document.addEventListener('DOMContentLoaded', function() {
//    loadCategories('addCategory');
//    loadCategories('editCategory');
//    setupPagination();
//    setupBulkActions();

//    setupImagePreview('courseImage', 'previewImage', 'uploadArea');
//    setupImagePreview('editCourseImage', 'editPreviewImage', 'editUploadArea');

//    setupSectionManagement('courseSectionsContainer', 'addSectionBtn', 'add');
//    setupSectionManagement('editCourseSectionsContainer', 'editAddSectionBtn', 'edit');

//    const openAddButtons = [
//        document.getElementById('openAddModal'),
//        document.getElementById('openAddModalEmpty')
//    ].filter(Boolean);

//    setupModal('addCourseModal', openAddButtons, document.getElementById('closeAddModal'));
//    setupModal('editCourseModal', null, document.getElementById('closeEditModal'));

//    document.getElementById('cancelAddCourse')?.addEventListener('click', function() {
//        document.getElementById('addCourseModal').style.display = 'none';
//        document.querySelector('#addCourseModal .modal-container').style.display = 'none';
//        document.body.style.overflow = 'auto';
//    });

//    document.getElementById('cancelEditCourse')?.addEventListener('click', function() {
//        document.getElementById('editCourseModal').style.display = 'none';
//        document.querySelector('#editCourseModal .modal-container').style.display = 'none';
//        document.body.style.overflow = 'auto';
//    });

//    document.getElementById('addCourseForm')?.addEventListener('submit', function(e) {
//        e.preventDefault();

//        const formData = new FormData(this);

//        const sections = [];
//        const sectionElements = document.querySelectorAll('#courseSectionsContainer [data-section-id]');

//        sectionElements.forEach(sectionElement => {
//            const sectionId = sectionElement.getAttribute('data-section-id');
//            const sectionTitle = sectionElement.querySelector('[name="add-section-title"]').value;

//            const section = {
//                title: sectionTitle,
//                lectures: []
//            };

//            const lessonElements = sectionElement.querySelectorAll('.lesson-item');
//            lessonElements.forEach(lessonElement => {
//                const lessonTitle = lessonElement.querySelector('[name="add-lesson-title"]').value;
//                const lessonType = lessonElement.querySelector('[name="add-lesson-type"]').value;

//                section.lectures.push({
//                    title: lessonTitle,
//                    type: lessonType
//                });

//                const videoInput = lessonElement.querySelector('.video-upload');
//                if (videoInput.files.length > 0) {
//                    formData.append(`videos`, videoInput.files[0]);
//                }
//            });

//            sections.push(section);
//        });

//        formData.set('sections', JSON.stringify(sections));

//        submitAddForm(formData);
//    });

//    document.querySelectorAll('.edit-course').forEach(button => {
//        button.addEventListener('click', function() {
//            const courseId = this.getAttribute('data-course-id');
//            fetchCourseForEdit(courseId);
//        });
//    });

//    document.getElementById('editCourseForm')?.addEventListener('submit', function(e) {
//        e.preventDefault();
        
//        const formData = new FormData(this);

//        const sections = [];
//        const sectionElements = document.querySelectorAll('#editCourseSectionsContainer [data-section-id]');

//        sectionElements.forEach(sectionElement => {
//            const sectionId = sectionElement.getAttribute('data-section-id');
//            const sectionTitle = sectionElement.querySelector('[name="edit-section-title"]').value;

//            const section = {
//                title: sectionTitle,
//                lectures: []
//            };

//            const lessonElements = sectionElement.querySelectorAll('.lesson-item');
//            lessonElements.forEach(lessonElement => {
//                const lessonTitle = lessonElement.querySelector('[name="edit-lesson-title"]').value;
//                const lessonType = lessonElement.querySelector('[name="edit-lesson-type"]').value;

//                section.lectures.push({
//                    title: lessonTitle,
//                    type: lessonType
//                });

//                const videoInput = lessonElement.querySelector('.video-upload');
//                if (videoInput.files.length > 0) {
//                    formData.append(`videos`, videoInput.files[0]);
//                }
//            });

//            sections.push(section);
//        });

//        formData.set('sections', JSON.stringify(sections));

//        submitEditForm(formData);
//    });

//    const searchInput = document.getElementById('searchInput');
//    const categoryFilter = document.getElementById('categoryFilter');
//    const statusFilter = document.getElementById('statusFilter');
//    const resetBtn = document.getElementById('resetFilters');
//    const rows = document.querySelectorAll('tbody tr');

//    function filterRows() {
//        const searchTerm = searchInput.value.toLowerCase();
//        const categoryValue = categoryFilter.value;
//        const statusValue = statusFilter.value;

//        rows.forEach(row => {
//            if (row.querySelector('td:first-child div:first-child') === null) return;

//            const title = row.querySelector('td:first-child div:first-child').textContent.toLowerCase();
//            const category = row.querySelector('td:nth-child(2)').textContent;
//            const status = row.querySelector('td:nth-child(5) span').textContent.trim();

//            const matchesSearch = title.includes(searchTerm);
//            const matchesCategory = categoryValue === '' || category === categoryValue;
//            const matchesStatus = statusValue === '' || status === statusValue;

//            if (matchesSearch && matchesCategory && matchesStatus) {
//                row.style.display = '';
//            } else {
//                row.style.display = 'none';
//            }
//        });
//    }

//    if (searchInput) searchInput.addEventListener('input', filterRows);
//    if (categoryFilter) categoryFilter.addEventListener('change', filterRows);
//    if (statusFilter) statusFilter.addEventListener('change', filterRows);
//    if (resetBtn) resetBtn.addEventListener('click', function() {
//        if (searchInput) searchInput.value = '';
//        if (categoryFilter) categoryFilter.value = '';
//        if (statusFilter) statusFilter.value = '';
//        filterRows();
//    });

//    document.querySelectorAll('.view-details').forEach(btn => {
//        btn.addEventListener('click', function() {
//            const courseId = this.getAttribute('data-course-id');
//            fetchCourseDetails(courseId);
//        });
//    });

//    document.getElementById('closeDetailsModal')?.addEventListener('click', closeDetailsModal);
//    document.getElementById('closeDetailsModalBtn')?.addEventListener('click', closeDetailsModal);

//    document.querySelectorAll('.delete-course').forEach(btn => {
//        btn.addEventListener('click', function() {
//            const courseId = this.getAttribute('data-course-id');
//            const courseName = this.getAttribute('data-course-name');
//            showDeleteConfirmation(courseId, courseName);
//        });
//    });
//});

