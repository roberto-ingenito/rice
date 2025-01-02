import materialDynamicColors from "material-dynamic-colors";
import colorthief from "colorthief";
import fs from "fs";
import path from "path";

function rgbToHex(rgb) {
    return '#' + rgb.map(x => x.toString(16).padStart(2, '0')).join('');
}

let inputColor;

try {
    const res = await colorthief.getPalette(process.argv[2]);
    inputColor = rgbToHex(res[0]);
} catch (error) {
    console.log(error);
    process.exit(1);
}

let jsonResult;

try {
    jsonResult = await materialDynamicColors(inputColor);
} catch (e) {
    console.log("Errore: ", e.message);
    process.exit(1);
}



// Costruisci il contenuto del file .rasi direttamente durante la riduzione
const rasiContent = `* {\n${Object.entries(jsonResult)
    .flatMap(([theme, colors]) =>
        Object.entries(colors).map(
            ([key, value]) => `\t${theme}-${key}: ${value};`
        )
    )
    .join('\n')}\n}`;


// Converti l'oggetto jsonResult al formato richiesto
const confContent = Object.entries(jsonResult)
    .flatMap(([theme, colors]) =>
        Object.entries(colors).map(
            ([key, value]) => `set $${theme}-${key} ${value}`
        )
    )
    .join('\n');



// Converti l'oggetto jsonResult al formato richiesto
const cssContent = Object.entries(jsonResult)
    .flatMap(([theme, colors]) =>
        Object.entries(colors).map(
            ([key, value]) => `@define-color ${theme}-${key} ${value};`
        )
    )
    .join('\n');


fs.writeFileSync('theme.rasi', rasiContent);
fs.writeFileSync('colors.conf', confContent);
fs.writeFileSync('colors.css', cssContent);
