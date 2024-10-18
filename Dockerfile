FROM ubuntu:jammy AS node

ENV DEBIAN_FRONTEND=noninteractive
ENV NVM_DIR "/root/.nvm"
ENV NVM_VERSION "0.39.7"
ENV NODE_VERSION "20.11.0"
ENV NODE_PATH "$NVM_DIR/v$NODE_VERSION/lib/node_modules"
ENV PATH "$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH"

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt update && apt -y install curl libatomic1 ffmpeg make python3 gcc g++ lsb-core && apt-get clean
RUN curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VERSION/install.sh" | bash && rm -rf "$NVM_DIR/.cache"

FROM node AS base

ARG PLAYWRIGHT_VERSION "latest"

RUN npm i -g playwright-core@$PLAYWRIGHT_VERSION && rm -rf /root/.npm

ENV IMAGE_INFO="$(lsb_release -ds), Node $(node -v), Playwright $(playwright-core -V)"
CMD eval echo $IMAGE_INFO

FROM base AS chromium

RUN playwright-core install --with-deps chromium

ENV IMAGE_INFO="$IMAGE_INFO, $($(echo /root/.cache/ms-playwright/chromium-*/chrome-linux/chrome) --version)"

FROM base AS firefox

RUN playwright-core install --with-deps firefox

ENV IMAGE_INFO="$IMAGE_INFO, $($(echo /root/.cache/ms-playwright/firefox-*/firefox/firefox) --version)"

FROM base AS webkit

RUN [ $(arch) == "armv7l" ] || playwright-core install --with-deps webkit

ENV IMAGE_INFO="$IMAGE_INFO, $($(echo /root/.cache/ms-playwright/webkit-*/minibrowser-wpe/MiniBrowser) --version)"

FROM base AS chrome

RUN [ $(arch) == "armv7l" ] || [ $(arch) == "aarch64" ] || playwright-core install --with-deps chrome

ENV IMAGE_INFO="$IMAGE_INFO, $(/usr/bin/google-chrome --version)"

FROM base AS msedge

RUN apt update && apt -y install gnupg && apt-get clean
RUN [ $(arch) == "armv7l" ] || [ $(arch) == "aarch64" ] || playwright-core install --with-deps msedge

ENV IMAGE_INFO="$IMAGE_INFO, $(/usr/bin/microsoft-edge --version)"

FROM chromium AS all

ENV IMAGE_INFO="$IMAGE_INFO, $($(echo /root/.cache/ms-playwright/firefox-*/firefox/firefox) --version)"
ENV IMAGE_INFO="$IMAGE_INFO, $($(echo /root/.cache/ms-playwright/webkit-*/minibrowser-wpe/MiniBrowser) --version)"
ENV IMAGE_INFO="$IMAGE_INFO, $(/usr/bin/google-chrome --version)"
ENV IMAGE_INFO="$IMAGE_INFO, $(/usr/bin/microsoft-edge --version)"

RUN apt update && apt -y install gnupg && apt-get clean
RUN playwright-core install --with-deps firefox
RUN [ $(arch) == "armv7l" ] || playwright-core install --with-deps webkit
RUN [ $(arch) == "armv7l" ] || [ $(arch) == "aarch64" ] || playwright-core install --with-deps chrome
RUN [ $(arch) == "armv7l" ] || [ $(arch) == "aarch64" ] || playwright-core install --with-deps msedge

### Lightweight Playwright ###

FROM node:alpine AS base-light

ARG PLAYWRIGHT_VERSION "latest"

RUN npm i -g playwright-core@$PLAYWRIGHT_VERSION && rm -rf /root/.npm
CMD eval echo $IMAGE_INFO

ENV IMAGE_INFO="Alpine $(cat /etc/alpine-release), Node $(node -v), Playwright $(playwright-core -V)"

FROM base-light AS chromium-light

RUN apk update && apk add --no-cache chromium

ENV IMAGE_INFO="$IMAGE_INFO, $(/usr/bin/chromium --version)"

### Playwright Server ###

FROM chromium AS chromium-server

WORKDIR /server

COPY server/ .
RUN npm link playwright-core && npm install

CMD ["node", "index.mjs"]

FROM firefox AS firefox-server

WORKDIR /server

COPY server/ .
RUN npm link playwright-core && npm install

CMD ["node", "index.mjs"]

FROM webkit AS webkit-server

WORKDIR /server

COPY server/ .
RUN npm link playwright-core && npm install

CMD ["node", "index.mjs"]

FROM chrome AS chrome-server

WORKDIR /server

COPY server/ .
RUN npm link playwright-core && npm install

CMD ["node", "index.mjs"]

FROM msedge AS msedge-server

WORKDIR /server

COPY server/ .
RUN npm link playwright-core && npm install

CMD ["node", "index.mjs"]

FROM chromium-light AS chromium-light-server

WORKDIR /server

COPY server/ .
RUN npm link playwright-core && npm install

CMD ["node", "index.mjs"]
