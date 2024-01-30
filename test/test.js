import { existsSync } from "fs";
import { chromium, firefox, webkit } from "playwright-core";

export async function test(TESTS) {
    if (TESTS[process.arch] === undefined) {
        console.log(`Skipping tests for ${process.arch}`);
    }

    for (const type of TESTS[process.arch]) {
        const browser = await launch(type);
        const page = await browser.newPage();

        await page.goto("https://html5test.opensuse.org/");
        await page.waitForSelector("#score strong");

        await page.screenshot({ path: `artifacts/${process.arch}-${type}.png`, fullPage: true });
        await page.close();
        await browser.close();
    }
}

async function launch(type) {
    switch (type) {
        case "chromium":
            return existsSync("/etc/alpine-release") ? await chromium.launch({ executablePath: "/usr/bin/chromium" }) : await chromium.launch();
        case "firefox":
            return await firefox.launch();
        case "webkit":
            return await webkit.launch();
        case "chrome":
            return await chromium.launch({ executablePath: "/usr/bin/google-chrome" });
        case "msedge":
            return await chromium.launch({ executablePath: "/usr/bin/microsoft-edge" });
        default:
            throw new Error(`Unknown browser type: ${type}`);
    }
}
