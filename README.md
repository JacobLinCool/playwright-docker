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

## Supported Architectures

| Browser  | ARMv7 (`armv7l`) | ARMv8 (`aarch64`) | AMD64 (`x86_64`) |
| -------- | :--------------: | :---------------: | :--------------: |
| Chromium |        ✅         |         ✅         |        ✅         |
| Firefox  |        ✅         |         ✅         |        ✅         |
| WebKit   |        ❌         |         ✅         |        ✅         |
| Chrome   |        ❌         |         ❌         |        ✅         |
| Edge     |        ❌         |         ❌         |        ✅         |

### Lightweight Image Architectures

| Browser  | ARMv7 (`armv7l`) | ARMv8 (`aarch64`) | AMD64 (`x86_64`) |
| -------- | :--------------: | :---------------: | :--------------: |
| Chromium |        ❌         |         ✅         |        ✅         |

## Sources

GitHub: <https://github.com/JacobLinCool/playwright-docker>
