// Initialize Dropzone for lesson content upload
document.addEventListener('DOMContentLoaded', function () {
    // Course image upload
    if (document.getElementById('course-image-dropzone')) {
        new Dropzone('#course-image-dropzone', {
            url: '/instructor/courses/upload-image',
            paramName: 'file',
            maxFiles: 1,
            maxFilesize: 5, // MB
            acceptedFiles: 'image/*',
            addRemoveLinks: true,
            dictDefaultMessage: 'اسحب وأسقط صورة الدورة هنا أو انقر للاختيار',
            dictFallbackMessage: 'المتصفح الخاص بك لا يدعم رفع الملفات بالسحب والإفلات',
            dictFileTooBig: 'الملف كبير جدًا ({{filesize}}MB). الحد الأقصى: {{maxFilesize}}MB.',
            dictInvalidFileType: 'لا يمكنك رفع ملفات من هذا النوع.',
            dictResponseError: 'الخادم رد بـ {{statusCode}}',
            dictCancelUpload: 'إلغاء الرفع',
            dictUploadCanceled: 'تم إلغاء الرفع',
            dictRemoveFile: 'إزالة الملف',
            dictMaxFilesExceeded: 'لا يمكنك رفع أكثر من ملف واحد.',
            init: function () {
                this.on('success', function (file, response) {
                    // Set the hidden input value with the uploaded image path
                    document.getElementById('course_image').value = response.path;
                });
                this.on('removedfile', function () {
                    // Clear the hidden input value when file is removed
                    document.getElementById('course_image').value = '';
                });
            }
        });
    }

    // Lesson video upload
    if (document.getElementById('lesson-video-dropzone')) {
        new Dropzone('#lesson-video-dropzone', {
            url: '/instructor/lessons/upload-video',
            paramName: 'file',
            maxFiles: 1,
            maxFilesize: 100, // MB (larger for videos)
            acceptedFiles: 'video/*',
            addRemoveLinks: true,
            dictDefaultMessage: 'اسحب وأسقط فيديو الدرس هنا أو انقر للاختيار',
            dictFallbackMessage: 'المتصفح الخاص بك لا يدعم رفع الملفات بالسحب والإفلات',
            dictFileTooBig: 'الملف كبير جدًا ({{filesize}}MB). الحد الأقصى: {{maxFilesize}}MB.',
            dictInvalidFileType: 'لا يمكنك رفع ملفات من هذا النوع.',
            dictResponseError: 'الخادم رد بـ {{statusCode}}',
            dictCancelUpload: 'إلغاء الرفع',
            dictUploadCanceled: 'تم إلغاء الرفع',
            dictRemoveFile: 'إزالة الملف',
            dictMaxFilesExceeded: 'لا يمكنك رفع أكثر من ملف واحد.',
            init: function () {
                this.on('success', function (file, response) {
                    // Set the hidden input value with the uploaded video path
                    document.getElementById('lesson_video').value = response.path;
                });
                this.on('removedfile', function () {
                    // Clear the hidden input value when file is removed
                    document.getElementById('lesson_video').value = '';
                });
            }
        });
    }

    // Handle section and lesson management
    const sectionsContainer = document.getElementById('sections-container');
    if (sectionsContainer) {
        // Add new section
        document.getElementById('add-section-btn').addEventListener('click', function () {
            const sectionId = Date.now();
            const sectionHtml = `
                <div class="section-item mb-6 p-4 border border-gray-200 dark:border-gray-700 rounded-lg" data-section-id="${sectionId}">
                    <div class="flex justify-between items-center mb-3">
                        <h3 class="text-lg font-medium text-gray-800 dark:text-white">قسم جديد</h3>
                        <button type="button" class="delete-section-btn text-red-600 hover:text-red-800">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                    <div class="mb-4">
                        <label class="instructor-form-label">عنوان القسم</label>
                        <input type="text" name="sections[${sectionId}][title]" class="instructor-form-input" required>
                    </div>
                    <div class="mb-4">
                        <label class="instructor-form-label">وصف القسم</label>
                        <textarea name="sections[${sectionId}][description]" class="instructor-form-textarea" rows="2"></textarea>
                    </div>
                    <div class="lessons-container mb-4 space-y-4"></div>
                    <button type="button" class="add-lesson-btn inline-flex items-center px-3 py-1 bg-gray-200 dark:bg-gray-700 hover:bg-gray-300 dark:hover:bg-gray-600 rounded-md text-sm">
                        <i class="fas fa-plus mr-1"></i> إضافة درس
                    </button>
                </div>
            `;
            sectionsContainer.insertAdjacentHTML('beforeend', sectionHtml);
        });

        // Delete section
        sectionsContainer.addEventListener('click', function (e) {
            if (e.target.closest('.delete-section-btn')) {
                e.target.closest('.section-item').remove();
            }
        });

        // Add new lesson
        sectionsContainer.addEventListener('click', function (e) {
            if (e.target.closest('.add-lesson-btn')) {
                const sectionItem = e.target.closest('.section-item');
                const sectionId = sectionItem.dataset.sectionId;
                const lessonsContainer = sectionItem.querySelector('.lessons-container');
                const lessonId = Date.now();

                const lessonHtml = `
                    <div class="lesson-item p-3 border border-gray-200 dark:border-gray-700 rounded-lg" data-lesson-id="${lessonId}">
                        <div class="flex justify-between items-center mb-2">
                            <h4 class="text-md font-medium text-gray-800 dark:text-white">درس جديد</h4>
                            <button type="button" class="delete-lesson-btn text-red-600 hover:text-red-800">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label class="instructor-form-label">عنوان الدرس</label>
                                <input type="text" name="sections[${sectionId}][lessons][${lessonId}][title]" class="instructor-form-input" required>
                            </div>
                            <div>
                                <label class="instructor-form-label">مدة الدرس (دقائق)</label>
                                <input type="number" name="sections[${sectionId}][lessons][${lessonId}][duration]" class="instructor-form-input" min="1" value="10">
                            </div>
                        </div>
                        <div class="mt-3">
                            <label class="instructor-form-label">وصف الدرس</label>
                            <textarea name="sections[${sectionId}][lessons][${lessonId}][description]" class="instructor-form-textarea" rows="2"></textarea>
                        </div>
                        <div class="mt-3">
                            <label class="instructor-form-label">نوع المحتوى</label>
                            <select name="sections[${sectionId}][lessons][${lessonId}][content_type]" class="instructor-form-select">
                                <option value="video">فيديو</option>
                                <option value="article">مقال</option>
                                <option value="quiz">اختبار</option>
                            </select>
                        </div>
                        <div class="mt-3 video-upload" style="display: none;">
                            <label class="instructor-form-label">رفع فيديو الدرس</label>
                            <div id="lesson-video-dropzone-${lessonId}" class="dropzone"></div>
                            <input type="hidden" name="sections[${sectionId}][lessons][${lessonId}][video_path]" id="lesson_video_${lessonId}">
                        </div>
                    </div>
                `;
                lessonsContainer.insertAdjacentHTML('beforeend', lessonHtml);

                // Initialize Dropzone for this lesson's video
                new Dropzone(`#lesson-video-dropzone-${lessonId}`, {
                    url: '/instructor/lessons/upload-video',
                    paramName: 'file',
                    maxFiles: 1,
                    maxFilesize: 100,
                    acceptedFiles: 'video/*',
                    addRemoveLinks: true,
                    dictDefaultMessage: 'اسحب وأسقط فيديو الدرس هنا أو انقر للاختيار',
                    init: function () {
                        this.on('success', function (file, response) {
                            document.getElementById(`lesson_video_${lessonId}`).value = response.path;
                        });
                        this.on('removedfile', function () {
                            document.getElementById(`lesson_video_${lessonId}`).value = '';
                        });
                    }
                });

                // Show/hide video upload based on content type
                const contentTypeSelect = document.querySelector(`select[name="sections[${sectionId}][lessons][${lessonId}][content_type]"]`);
                const videoUploadDiv = document.querySelector(`.lesson-item[data-lesson-id="${lessonId}"] .video-upload`);

                contentTypeSelect.addEventListener('change', function () {
                    if (this.value === 'video') {
                        videoUploadDiv.style.display = 'block';
                    } else {
                        videoUploadDiv.style.display = 'none';
                    }
                });
            }
        });

        // Delete lesson
        sectionsContainer.addEventListener('click', function (e) {
            if (e.target.closest('.delete-lesson-btn')) {
                e.target.closest('.lesson-item').remove();
            }
        });
    }
});

// Submit course for review
function submitForReview(courseId) {
    if (confirm('هل أنت متأكد أنك تريد إرسال الدورة للمراجعة؟ بعد الإرسال لا يمكنك التعديل حتى تتم الموافقة.')) {
        fetch(`/instructor/courses/${courseId}/submit`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            }
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('تم إرسال الدورة للمراجعة بنجاح');
                    window.location.reload();
                } else {
                    alert('حدث خطأ أثناء إرسال الدورة: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('حدث خطأ أثناء إرسال الدورة');
            });
    }
}