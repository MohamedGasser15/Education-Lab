const fs = require('fs');
const path = require('path');

const translations = {
    'OrUp': {
        'en': '&amp; up',
        'ar': 'أو أعلى',
        'de': 'und höher',
        'es': 'o más',
        'fr': 'et plus',
        'hi': 'और ऊपर',
        'id': 'dan ke atas',
        'it': 'o superiore',
        'ja': '以上',
        'ko': '이상',
        'ms': 'dan ke atas',
        'nl': 'en hoger',
        'pl': 'i wyżej',
        'pt': 'ou mais',
        'ru': 'и выше',
        'tr': 've üzeri',
        'uk': 'і вище',
        'ur': 'اور اس سے اوپر',
        'vi': 'trở lên',
        'zh': '及以上'
    },
    'Free': {
        'en': 'Free',
        'ar': 'مجاني',
        'de': 'Kostenlos',
        'es': 'Gratis',
        'fr': 'Gratuit',
        'hi': 'मुफ़्त',
        'id': 'Gratis',
        'it': 'Gratuito',
        'ja': '無料',
        'ko': '무료',
        'ms': 'Percuma',
        'nl': 'Gratis',
        'pl': 'Za darmo',
        'pt': 'Grátis',
        'ru': 'Бесплатно',
        'tr': 'Ücretsiz',
        'uk': 'Безкоштовно',
        'ur': 'مفت',
        'vi': 'Miễn phí',
        'zh': '免费'
    },
    'UnderPrice': {
        'en': 'Under',
        'ar': 'أقل من',
        'de': 'Unter',
        'es': 'Menos de',
        'fr': 'Moins de',
        'hi': 'से कम',
        'id': 'Di bawah',
        'it': 'Sotto',
        'ja': '未満',
        'ko': '미만',
        'ms': 'Bawah',
        'nl': 'Onder',
        'pl': 'Poniżej',
        'pt': 'Menos de',
        'ru': 'Меньше',
        'tr': 'Altında',
        'uk': 'Менше',
        'ur': 'سے کم',
        'vi': 'Dưới',
        'zh': '低于'
    }
};

const resourcesDir = path.join(__dirname, 'Resources');
const files = fs.readdirSync(resourcesDir).filter(f => f.startsWith('SharedResources') && f.endsWith('.resx'));

for (const file of files) {
    let lang = 'en';
    let langMatch = file.match(/SharedResources\.([a-z]{2})\.resx/);
    if (langMatch) {
        lang = langMatch[1];
    }

    const filePath = path.join(resourcesDir, file);
    let content = fs.readFileSync(filePath, 'utf8');
    let changed = false;

    for (const [key, langMap] of Object.entries(translations)) {
        let val = langMap[lang] || langMap['en'];

        // If key exists, replace it
        const regex = new RegExp(`(<data name="${key}"[^>]*>[\\s\\S]*?<value>)(.*?)(<\\/value>[\\s\\S]*?<\\/data>)`);
        if (regex.test(content)) {
            content = content.replace(regex, `$1${val}$3`);
            changed = true;
        } else {
            // Otherwise append it
            const newNode = `  <data name="${key}" xml:space="preserve">\r\n    <value>${val}</value>\r\n  </data>\r\n`;
            content = content.replace('</root>', newNode + '</root>');
            changed = true;
        }
    }

    if (changed) {
        fs.writeFileSync(filePath, content, 'utf8');
        console.log(`Updated translations for ${lang} in ${file}`);
    }
}
