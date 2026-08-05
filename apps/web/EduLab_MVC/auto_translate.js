const fs = require('fs');
const path = require('path');

// We will use the dynamically imported translate api
(async () => {
    // Dynamic import for ESM package in CommonJS
    const { translate } = await import('@vitalets/google-translate-api');

    const resourcesDir = path.join(__dirname, 'Resources');
    const en = fs.readFileSync(path.join(resourcesDir, 'SharedResources.resx'), 'utf8');

    const enKeys = {};
    for (const match of en.matchAll(/<data name="([^"]+)"[^>]*>[\s\S]*?<value>(.*?)<\/value>/g)) {
        enKeys[match[1]] = match[2].trim();
    }

    const files = fs.readdirSync(resourcesDir).filter(f => f.startsWith('SharedResources') && f.endsWith('.resx'));

    for (const file of files) {
        let langMatch = file.match(/SharedResources\.([a-z]{2})\.resx/);
        if (!langMatch) continue;
        if (file === 'SharedResources.ar.resx') continue; // Skip Arabic

        let lang = langMatch[1];
        if (lang === 'zh') lang = 'zh-CN'; // Google translate uses zh-CN
        
        const filePath = path.join(resourcesDir, file);
        let content = fs.readFileSync(filePath, 'utf8');
        
        const untranslated = [];
        for (const match of content.matchAll(/<data name="([^"]+)"[^>]*>[\s\S]*?<value>(.*?)<\/value>/g)) {
            const key = match[1];
            const val = match[2].trim();
            // If the German value is exactly the English value, it's an untranslated fallback
            if (enKeys[key] && enKeys[key] === val && key !== 'Logo' && key !== 'EGP' && key !== 'Favicon' && key !== 'WhatsApp' && key !== 'CVV') {
                untranslated.push({ key, val });
            }
        }

        if (untranslated.length > 0) {
            console.log(`Translating ${untranslated.length} keys for ${lang}...`);
            
            for (const item of untranslated) {
                try {
                    // Small delay to prevent API blocking
                    await new Promise(r => setTimeout(r, 200));
                    
                    const res = await translate(item.val, { to: lang });
                    const translatedText = res.text;
                    
                    // Replace in content
                    const regex = new RegExp(`(<data name="${item.key}"[^>]*>[\\s\\S]*?<value>)(.*?)(<\\/value>[\\s\\S]*?<\\/data>)`);
                    content = content.replace(regex, `$1${translatedText}$3`);
                    console.log(`  ${lang}: ${item.key} -> ${translatedText}`);
                } catch (e) {
                    console.error(`  Error translating ${item.key} to ${lang}: ${e.message}`);
                }
            }
            
            fs.writeFileSync(filePath, content, 'utf8');
            console.log(`Saved translations for ${lang}.`);
        }
    }
})();
