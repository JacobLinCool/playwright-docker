#!/bin/sh
cd $(dirname $0)
docker run --rm -v "$(pwd):/test" -w "/test" jacoblincool/playwright:all node normal.js
docker run --rm -v "$(pwd):/test" -w "/test" jacoblincool/playwright:chromium-light node light.js
