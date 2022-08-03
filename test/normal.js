import { test } from "./test.js";

const TESTS = {
    arm: ["chromium", "firefox"],
    arm64: ["chromium", "firefox", "webkit"],
    x64: ["chromium", "firefox", "webkit", "chrome", "msedge"],
};

test(TESTS);
