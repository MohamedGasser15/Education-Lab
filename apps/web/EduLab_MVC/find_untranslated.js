const fs = require('fs');
const path = require('path');

const en = fs.readFileSync(path.join(__dirname, 'Resources', 'SharedResources.resx'), 'utf8');
const de = fs.readFileSync(path.join(__dirname, 'Resources', 'SharedResources.de.resx'), 'utf8');

const enKeys = {};
for (const match of en.matchAll(/<data name="([^"]+)"[^>]*>[\s\S]*?<value>(.*?)<\/value>/g)) {
    enKeys[match[1]] = match[2].trim();
}

const untranslated = [];
for (const match of de.matchAll(/<data name="([^"]+)"[^>]*>[\s\S]*?<value>(.*?)<\/value>/g)) {
    const key = match[1];
    const val = match[2].trim();
    if (enKeys[key] && enKeys[key] === val) {
        // If the German value is exactly the English value, it's untranslated fallback
        untranslated.push({ key, val });
    }
}

console.log("Found " + untranslated.length + " untranslated keys.");
untranslated.forEach(k => console.log(k.key + ": " + k.val));
