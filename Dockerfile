FROM ubuntu:focal as node

ENV DEBIAN_FRONTEND=noninteractive
ENV NVM_DIR "/root/.nvm"
ENV NVM_VERSION "0.39.1"
ENV NODE_VERSION "18.7.0"
ENV NODE_PATH "$NVM_DIR/v$NODE_VERSION/lib/node_modules"
ENV PATH "$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH"

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt update && apt -y install curl libatomic1 ffmpeg make python3 gcc g++ lsb-core && apt-get clean
RUN curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VERSION/install.sh" | bash && rm -rf "$NVM_DIR/.cache"

FROM node as base

ENV IMAGE_INFO="$(lsb_release -ds), Node $(node -v), Playwright $(playwright -V)"

RUN npm i -g playwright-core && rm -rf /root/.npm
CMD eval echo $IMAGE_INFO

FROM base as pnpm

ENV PNPM_HOME="/root/.local/share/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN npm i -g pnpm && rm -rf /root/.npm

FROM pnpm as chromium

ENV IMAGE_INFO="$IMAGE_INFO, $($(echo /root/.cache/ms-playwright/chromium-*/chrome-linux/chrome) --version)"

RUN playwright install --with-deps chromium

FROM pnpm as firefox

ENV IMAGE_INFO="$IMAGE_INFO, $($(echo /root/.cache/ms-playwright/firefox-*/firefox/firefox) --version)"

RUN playwright install --with-deps firefox

FROM pnpm as webkit

ENV IMAGE_INFO="$IMAGE_INFO, $($(echo /root/.cache/ms-playwright/webkit-*/minibrowser-wpe/MiniBrowser) --version)"

RUN [ $(arch) == "armv7l" ] || playwright install --with-deps webkit

FROM pnpm as chrome

ENV IMAGE_INFO="$IMAGE_INFO, $(/usr/bin/google-chrome --version)"

RUN [ $(arch) == "armv7l" ] || [ $(arch) == "aarch64" ] || playwright install --with-deps chrome

FROM pnpm as msedge

ENV IMAGE_INFO="$IMAGE_INFO, $(/usr/bin/microsoft-edge --version)"

RUN apt update && apt -y install gnupg && apt-get clean
RUN [ $(arch) == "armv7l" ] || [ $(arch) == "aarch64" ] || playwright install --with-deps msedge

FROM chromium as all

ENV IMAGE_INFO="$IMAGE_INFO, $($(echo /root/.cache/ms-playwright/firefox-*/firefox/firefox) --version)"
ENV IMAGE_INFO="$IMAGE_INFO, $($(echo /root/.cache/ms-playwright/webkit-*/minibrowser-wpe/MiniBrowser) --version)"
ENV IMAGE_INFO="$IMAGE_INFO, $(/usr/bin/google-chrome --version)"
ENV IMAGE_INFO="$IMAGE_INFO, $(/usr/bin/microsoft-edge --version)"

RUN apt update && apt -y install gnupg && apt-get clean
RUN playwright install --with-deps firefox
RUN [ $(arch) == "armv7l" ] || playwright install --with-deps webkit
RUN [ $(arch) == "armv7l" ] || [ $(arch) == "aarch64" ] || playwright install --with-deps chrome
RUN [ $(arch) == "armv7l" ] || [ $(arch) == "aarch64" ] || playwright install --with-deps msedge

### Lightweight Playwright ###

FROM node:alpine as base-light

ENV IMAGE_INFO="Alpine $(cat /etc/alpine-release), Node $(node -v), Playwright $(playwright -V)"

RUN npm i -g playwright-core && rm -rf /root/.npm
CMD eval echo $IMAGE_INFO

FROM base-light as chromium-light

ENV IMAGE_INFO="$IMAGE_INFO, $(/usr/bin/chromium --version)"

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk update && \
    apk add chromium && \
    ln -s /usr/bin/chromium-browser /usr/bin/chromium
