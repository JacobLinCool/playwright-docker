#!/bin/bash
npm i -g regctl
regctl registry login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_TOKEN

function get_version() {
    echo $1 | cut -d' ' -f2
}

regctl image copy jacoblincool/playwright:all jacoblincool/playwright:latest

tags=("base" "chromium" "firefox" "webkit" "chrome" "msedge" "all" "base-light" "chromium-light")
for tag in "${tags[@]}"; do
    docker pull jacoblincool/playwright:$tag
    ver=$(get_version "$(docker run --rm jacoblincool/playwright:$tag playwright-core --version)")
    regctl image copy jacoblincool/playwright:$tag jacoblincool/playwright:$tag-$ver
done

regctl registry logout
