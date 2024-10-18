# Playwright Docker Images

multi-arch x multi-browser

View on Docker Hub: [https://hub.docker.com/r/jacoblincool/playwright/](https://hub.docker.com/r/jacoblincool/playwright/)

## Tags

- `jacoblincool/playwright:base` - Ubuntu Jammy, Node 20, Playwright
- `jacoblincool/playwright:pnpm` - Ubuntu Jammy, Node 20, Playwright, PNPM
- `jacoblincool/playwright:chromium` - Ubuntu Jammy, Node 20, Playwright, PNPM, Chromium
- `jacoblincool/playwright:firefox` - Ubuntu Jammy, Node 20, Playwright, PNPM, Firefox
- `jacoblincool/playwright:webkit` - Ubuntu Jammy, Node 20, Playwright, PNPM, WebKit
- `jacoblincool/playwright:chrome` - Ubuntu Jammy, Node 20, Playwright, PNPM, Chrome
- `jacoblincool/playwright:msedge` - Ubuntu Jammy, Node 20, Playwright, PNPM, Edge
- `jacoblincool/playwright:all` - Ubuntu Jammy, Node 20, Playwright, PNPM, All Browsers

### Lightweight Images

- `jacoblincool/playwright:base-light` - Alpine 3.20, Node 23, Playwright
- `jacoblincool/playwright:chromium-light` - Alpine 3.20, Node 23, Playwright, Chromium

### Playwright Servers

Those images are running Playwright Server and expose the WebSocket endpoint, see [./server](./server) for more details.

- `jacoblincool/playwright:chromium-server`
- `jacoblincool/playwright:firefox-server`
- `jacoblincool/playwright:webkit-server`
- `jacoblincool/playwright:chrome-server`
- `jacoblincool/playwright:msedge-server`
- `jacoblincool/playwright:chromium-light-server`

The default endpoint is `ws://localhost:53333/playwright`, you can override it by setting the `BROWSER_PORT` and `BROWSER_WS_ENDPOINT` environment variables.

They can be run using the following command:

```sh
docker run --rm -p 53333:53333 jacoblincool/playwright:chromium-light-server
```

And connect to the server using Playwright:

```ts
import { chromium } from "playwright";
const browser = await chromium.connect("ws://localhost:53333/playwright");
```

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
