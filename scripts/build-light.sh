#!/bin/sh
docker buildx bake --push --set "*.platform=linux/arm64/v8,linux/amd64" base-light chromium-light
