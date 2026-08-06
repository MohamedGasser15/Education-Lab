const fs = require('fs');
const path = require('path');

const newKeys = {
    'MyLearning': 'My Learning',
    'TrackYourLearningJourney': 'Track your learning journey',
    'Certifications': 'Certifications',
    'SearchCoursesPlaceholder': 'Search courses...',
    'AllInstructors': 'All Instructors',
    'NoEnrolledCoursesMessage': 'You haven\'t enrolled in any courses yet.',
    'ReviewCourse': 'Review Course',
    'StartCourse': 'Start Course',
    'NoResultsFilterMessage': 'Try adjusting your filters to find what you\'re looking for.',
    'NoWishlistItems': 'No Items in Wishlist',
    'NoWishlistMessage': 'You haven\'t added any courses to your wishlist yet.',
    'SearchWishlistPlaceholder': 'Search wishlist...',
    'ConfirmRemoveWishlist': 'Are you sure you want to remove this course from your wishlist?',
    'ErrorRemovingWishlist': 'An error occurred while removing the course.'
};

(async () => {
    const { translate } = await import('@vitalets/google-translate-api');
    const resourcesDir = path.join(__dirname, 'Resources');
    const files = fs.readdirSync(resourcesDir).filter(f => f.startsWith('SharedResources') && f.endsWith('.resx'));

    for (const file of files) {
        let langMatch = file.match(/SharedResources\.([a-z]{2})\.resx/);
        let lang = langMatch ? langMatch[1] : 'en';
        
        const filePath = path.join(resourcesDir, file);
        let content = fs.readFileSync(filePath, 'utf8');
        let changed = false;

        for (const [key, enText] of Object.entries(newKeys)) {
            if (!content.includes(`name="${key}"`)) {
                let textToInject = enText;
                
                if (lang !== 'en') {
                    try {
                        let targetLang = lang;
                        if (targetLang === 'zh') targetLang = 'zh-CN';
                        
                        await new Promise(r => setTimeout(r, 200));
                        const res = await translate(enText, { to: targetLang });
                        textToInject = res.text;
                        console.log(`Translated [${key}] to ${lang}: ${textToInject}`);
                    } catch(e) {
                        console.error(`Error translating [${key}] to ${lang}: ${e.message}`);
                        // fallback to english
                        textToInject = enText;
                    }
                }
                
                const newNode = `  <data name="${key}" xml:space="preserve">\r\n    <value>${textToInject}</value>\r\n  </data>\r\n`;
                content = content.replace('</root>', newNode + '</root>');
                changed = true;
            }
        }

        if (changed) {
            fs.writeFileSync(filePath, content, 'utf8');
            console.log(`Updated ${file}`);
        }
    }
})();
