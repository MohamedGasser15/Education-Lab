const fs = require('fs');
const path = require('path');

const fixTranslations = {
    'zh': {
        'MyLearning': '我的学习',
        'TrackYourLearningJourney': '追踪您的学习旅程',
        'Certifications': '认证',
        'SearchCoursesPlaceholder': '搜索课程...',
        'AllInstructors': '所有讲师',
        'NoEnrolledCoursesMessage': '您尚未注册任何课程。',
        'ReviewCourse': '复习课程',
        'StartCourse': '开始课程',
        'NoResultsFilterMessage': '尝试调整您的过滤条件以找到您需要的内容。',
        'NoWishlistItems': '愿望清单中没有项目',
        'NoWishlistMessage': '您尚未将任何课程添加到您的愿望清单中。',
        'SearchWishlistPlaceholder': '搜索愿望清单...',
        'ConfirmRemoveWishlist': '您确定要从愿望清单中移除此课程吗？',
        'ErrorRemovingWishlist': '移除课程时发生错误。'
    },
    'vi': {
        'MyLearning': 'Học tập của tôi',
        'TrackYourLearningJourney': 'Theo dõi hành trình học tập của bạn',
        'Certifications': 'Chứng chỉ',
        'SearchCoursesPlaceholder': 'Tìm kiếm khóa học...',
        'AllInstructors': 'Tất cả giảng viên',
        'NoEnrolledCoursesMessage': 'Bạn chưa đăng ký khóa học nào.',
        'ReviewCourse': 'Ôn tập khóa học',
        'StartCourse': 'Bắt đầu khóa học',
        'NoResultsFilterMessage': 'Hãy thử điều chỉnh bộ lọc của bạn để tìm những gì bạn đang tìm kiếm.',
        'NoWishlistItems': 'Không có mục nào trong Danh sách mong muốn',
        'NoWishlistMessage': 'Bạn chưa thêm khóa học nào vào danh sách mong muốn của mình.',
        'SearchWishlistPlaceholder': 'Tìm kiếm danh sách mong muốn...',
        'ConfirmRemoveWishlist': 'Bạn có chắc chắn muốn xóa khóa học này khỏi danh sách mong muốn của mình không?',
        'ErrorRemovingWishlist': 'Đã xảy ra lỗi khi xóa khóa học.'
    },
    'ur': {
        'MyLearning': 'میری تعلیم',
        'TrackYourLearningJourney': 'اپنے سیکھنے کے سفر کو ٹریک کریں',
        'Certifications': 'سرٹیفیکیشن',
        'SearchCoursesPlaceholder': 'کورسز تلاش کریں...',
        'AllInstructors': 'تمام اساتذہ',
        'NoEnrolledCoursesMessage': 'آپ نے ابھی تک کسی کورس میں داخلہ نہیں لیا ہے۔',
        'ReviewCourse': 'کورس کا جائزہ لیں',
        'StartCourse': 'کورس شروع کریں',
        'NoResultsFilterMessage': 'جو آپ تلاش کر رہے ہیں اسے تلاش کرنے کے لیے اپنے فلٹرز کو ایڈجسٹ کرنے کی کوشش کریں۔',
        'NoWishlistItems': 'خواہش کی فہرست میں کوئی آئٹم نہیں',
        'NoWishlistMessage': 'آپ نے ابھی تک اپنی خواہش کی فہرست میں کوئی کورس شامل نہیں کیا ہے۔',
        'SearchWishlistPlaceholder': 'خواہش کی فہرست تلاش کریں...',
        'ConfirmRemoveWishlist': 'کیا آپ واقعی اس کورس کو اپنی خواہش کی فہرست سے ہٹانا چاہتے ہیں؟',
        'ErrorRemovingWishlist': 'کورس کو ہٹاتے وقت ایک خرابی پیش آ گئی۔'
    }
};

const resourcesDir = path.join(__dirname, 'Resources');
for (const [lang, translations] of Object.entries(fixTranslations)) {
    const file = `SharedResources.${lang}.resx`;
    const filePath = path.join(resourcesDir, file);
    if (!fs.existsSync(filePath)) continue;

    let content = fs.readFileSync(filePath, 'utf8');
    let changed = false;

    for (const [key, val] of Object.entries(translations)) {
        const regex = new RegExp(`(<data name="${key}"[^>]*>[\\s\\S]*?<value>)(.*?)(<\\/value>[\\s\\S]*?<\\/data>)`);
        if (regex.test(content)) {
            content = content.replace(regex, `$1${val}$3`);
            changed = true;
        }
    }

    if (changed) {
        fs.writeFileSync(filePath, content, 'utf8');
        console.log(`Updated translations for ${lang} in ${file}`);
    }
}
