import { chromium, firefox, webkit } from "playwright-core";
import { existsSync } from "node:fs";
import shellQuoteParse from "shell-quote/parse.js";

main();

async function main() {
    const server = await launch();
    console.log(server.wsEndpoint());
}

async function launch() {
    const info = (process.env.IMAGE_INFO || "").toLowerCase();

    // https://playwright.dev/docs/api/class-browsertype#browser-type-launch-server
    const options = {
        port: parseInt(process.env.BROWSER_PORT || 53333),
        wsPath: process.env.BROWSER_WS_ENDPOINT || "/playwright",
        channel: process.env.BROWSER_CHANNEL,
    }
    if (process.env.BROWSER_TIMEOUT) {
        options.timeout = parseInt(process.env.BROWSER_TIMEOUT)
    }
    if (process.env.BROWSER_PROXY_SERVER) {
        options.proxy = {
            server: process.env.BROWSER_PROXY_SERVER,
            bypass: process.env.BROWSER_PROXY_BYPASS,
            username: process.env.BROWSER_PROXY_USERNAME,
            password: process.env.BROWSER_PROXY_PASSWORD,
        }
    }
    if (process.env.BROWSER_ARGS) {
        options.args = shellQuoteParse(process.env.BROWSER_ARGS)
    }

    if (info.includes("chromium")) {
        return existsSync("/etc/alpine-release")
            ? await chromium.launchServer({ executablePath: "/usr/bin/chromium", ...options })
            : await chromium.launchServer(options);
    } else if (info.includes("firefox")) {
        return await firefox.launchServer(options);
    } else if (info.includes("webkit")) {
        return await webkit.launchServer(options);
    } else if (info.includes("chrome")) {
        return await chromium.launchServer({ executablePath: "/usr/bin/google-chrome", ...options });
    } else if (info.includes("msedge")) {
        return await chromium.launchServer({ executablePath: "/usr/bin/microsoft-edge", ...options });
    } else {
        throw new Error(`Unknown browser info: ${info}`);
    }
}
