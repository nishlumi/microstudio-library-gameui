/**
 * Compress assets/, assets_th/, doc/, ms/, sprites/, and project.json into a single zip file 
 * and save it in a format that can be imported into microStudio.
 * 
 */
const AdmZip = require('adm-zip');

try {
    const zip = new AdmZip();
    const outputFile = "gameui-library.zip";

    // Add directories
    zip.addLocalFolder("./assets", "assets");
    zip.addLocalFolder("./assets_th", "assets_th");
    zip.addLocalFolder("./doc", "doc");
    zip.addLocalFolder("./ms", "ms");
    zip.addLocalFolder("./sprites", "sprites");

    // Add a file
    zip.addLocalFile("./project.json");

    // Write the zip file
    zip.writeZip(outputFile);
    console.log(`Successfully created ${outputFile}`);
} catch (e) {
    console.log(`Something went wrong. ${e}`);
}
