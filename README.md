# Playwright Docker Images

multi-arch x multi-browser

View on Docker Hub: [https://hub.docker.com/r/jacoblincool/playwright/](https://hub.docker.com/r/jacoblincool/playwright/)

## Tags

- `jacoblincool/playwright:base` - Ubuntu Focal, Node 18, Playwright
- `jacoblincool/playwright:pnpm` - Ubuntu Focal, Node 18, Playwright, PNPM
- `jacoblincool/playwright:chromium` - Ubuntu Focal, Node 18, Playwright, PNPM, Chromium
- `jacoblincool/playwright:firefox` - Ubuntu Focal, Node 18, Playwright, PNPM, Firefox
- `jacoblincool/playwright:webkit` - Ubuntu Focal, Node 18, Playwright, PNPM, WebKit
- `jacoblincool/playwright:chrome` - Ubuntu Focal, Node 18, Playwright, PNPM, Chrome
- `jacoblincool/playwright:msedge` - Ubuntu Focal, Node 18, Playwright, PNPM, Edge
- `jacoblincool/playwright:all` - Ubuntu Focal, Node 18, Playwright, PNPM, All Browsers

### Lightweight Images

- `jacoblincool/playwright:base-light` - Alpine, Node 18, Playwright
- `jacoblincool/playwright:chromium-light` - Alpine, Node 18, Playwright, Chromium

### Playwright Servers

Those images are running Playwright Server and expose the WebSocket endpoint, see [./server](./server) for more details.

- `jacoblincool/playwright:chromium-server`
- `jacoblincool/playwright:firefox-server`
- `jacoblincool/playwright:webkit-server`
- `jacoblincool/playwright:chrome-server`
- `jacoblincool/playwright:msedge-server`
- `jacoblincool/playwright:chromium-light-server`

The default endpoint is `ws://localhost:53333/playwright`, you can override it by setting the `BROWSER_PORT` and `BROWSER_WS_ENDPOINT` environment variables.

## Supported Architectures

| Browser  | ARMv8 (`aarch64`) | AMD64 (`x86_64`) |
| -------- | :---------------: | :--------------: |
| Chromium |         ✅         |        ✅         |
| Firefox  |         ✅         |        ✅         |
| WebKit   |         ✅         |        ✅         |
| Chrome   |         ❌         |        ✅         |
| Edge     |         ❌         |        ✅         |

### Lightweight Image Architectures

| Browser  | ARMv8 (`aarch64`) | AMD64 (`x86_64`) |
| -------- | :---------------: | :--------------: |
| Chromium |         ✅         |        ✅         |

## Sources

GitHub: <https://github.com/JacobLinCool/playwright-docker>
