import { chromium, firefox, webkit } from "playwright-core";
import { existsSync } from "node:fs";

main();

async function main() {
    const server = await launch();
    console.log(server.wsEndpoint());
}

async function launch() {
    const info = (process.env.IMAGE_INFO || "").toLowerCase();
    const channel = process.env.BROWSER_CHANNEL;
    const port = process.env.BROWSER_PORT || 53333;
    const wsPath = process.env.BROWSER_WS_ENDPOINT || "/playwright";
    if (info.includes("chromium")) {
        return existsSync("/etc/alpine-release")
            ? await chromium.launchServer({ executablePath: "/usr/bin/chromium", port, wsPath })
            : await chromium.launchServer({ port, wsPath });
    } else if (info.includes("firefox")) {
        return await firefox.launchServer({ port, wsPath });
    } else if (info.includes("webkit")) {
        return await webkit.launchServer({ port, wsPath });
    } else if (info.includes("chrome")) {
        return await chromium.launchServer({ executablePath: "/usr/bin/google-chrome", channel, port, wsPath });
    } else if (info.includes("msedge")) {
        return await chromium.launchServer({ executablePath: "/usr/bin/microsoft-edge", channel, port, wsPath });
    } else {
        throw new Error(`Unknown browser info: ${info}`);
    }
}
