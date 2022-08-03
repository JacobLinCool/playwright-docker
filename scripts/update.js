const fs = require("node:fs");
const path = require("node:path");
const { execSync } = require("node:child_process");

const readme = fs.readFileSync(path.join(__dirname, "..", "README.md"), "utf8");
let new_readme = `See https://github.com/JacobLinCool/playwright-docker\n\n---\n\n` + readme;

const tag_regex = /`([a-z0-9/:-]+)` - ([^`\n]+)/g;

const matches = readme.matchAll(tag_regex);
if (matches) {
    for (const match of matches) {
        const [, tag, description] = match;

        execSync(`docker pull ${tag.trim()}`, { stdio: "inherit" });
        const info = execSync(`docker run --rm ${tag}`).toString().trim().replace("\n", " ");
        console.log(tag.trim(), info);

        new_readme = new_readme.replace(match[0], `\`${tag}\` - ${info}`);
    }
}

fs.writeFileSync(path.join(__dirname, "..", "README.md"), new_readme);
