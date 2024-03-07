FROM ubuntu:focal as node

ENV DEBIAN_FRONTEND=noninteractive
ENV NVM_DIR "/root/.nvm"
ENV NVM_VERSION "0.39.7"
ENV NODE_VERSION "20.11.0"
ENV NODE_PATH "$NVM_DIR/v$NODE_VERSION/lib/node_modules"
ENV PATH "$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH"

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt update && apt -y install curl libatomic1 ffmpeg make python3 gcc g++ lsb-core && apt-get clean
RUN curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VERSION/install.sh" | bash && rm -rf "$NVM_DIR/.cache"

FROM node as base

RUN npm i -g playwright-core && rm -rf /root/.npm

ENV IMAGE_INFO="$(lsb_release -ds), Node $(node -v), Playwright $(playwright-core -V)"
CMD eval echo $IMAGE_INFO

FROM base as pnpm

ENV PNPM_HOME="/root/.local/share/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN npm i -g pnpm && rm -rf /root/.npm

FROM pnpm as chromium

RUN playwright-core install --with-deps chromium

ENV IMAGE_INFO="$IMAGE_INFO, $($(echo /root/.cache/ms-playwright/chromium-*/chrome-linux/chrome) --version)"

FROM pnpm as firefox

RUN playwright-core install --with-deps firefox

ENV IMAGE_INFO="$IMAGE_INFO, $($(echo /root/.cache/ms-playwright/firefox-*/firefox/firefox) --version)"

FROM pnpm as webkit

RUN [ $(arch) == "armv7l" ] || playwright-core install --with-deps webkit

ENV IMAGE_INFO="$IMAGE_INFO, $($(echo /root/.cache/ms-playwright/webkit-*/minibrowser-wpe/MiniBrowser) --version)"

FROM pnpm as chrome

RUN [ $(arch) == "armv7l" ] || [ $(arch) == "aarch64" ] || playwright-core install --with-deps chrome

ENV IMAGE_INFO="$IMAGE_INFO, $(/usr/bin/google-chrome --version)"

FROM pnpm as msedge

RUN apt update && apt -y install gnupg && apt-get clean
RUN [ $(arch) == "armv7l" ] || [ $(arch) == "aarch64" ] || playwright-core install --with-deps msedge

ENV IMAGE_INFO="$IMAGE_INFO, $(/usr/bin/microsoft-edge --version)"

FROM chromium as all

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

FROM node:alpine as base-light

RUN npm i -g playwright-core && rm -rf /root/.npm
CMD eval echo $IMAGE_INFO

ENV IMAGE_INFO="Alpine $(cat /etc/alpine-release), Node $(node -v), Playwright $(playwright-core -V)"

FROM base-light as chromium-light

RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.18/main" > /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.18/community" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache chromium

ENV IMAGE_INFO="$IMAGE_INFO, $(/usr/bin/chromium --version)"

### Playwright Server ###

FROM chromium as chromium-server

WORKDIR /server

COPY server/ .
RUN pnpm install

CMD ["node", "index.mjs"]

FROM firefox as firefox-server

WORKDIR /server

COPY server/ .
RUN pnpm install

CMD ["node", "index.mjs"]

FROM webkit as webkit-server

WORKDIR /server

COPY server/ .
RUN pnpm install

CMD ["node", "index.mjs"]

FROM chrome as chrome-server

WORKDIR /server

COPY server/ .
RUN pnpm install

CMD ["node", "index.mjs"]

FROM msedge as msedge-server

WORKDIR /server

COPY server/ .
RUN pnpm install

CMD ["node", "index.mjs"]

FROM chromium-light as chromium-light-server

WORKDIR /server

COPY server/ .
RUN npm install

CMD ["node", "index.mjs"]
