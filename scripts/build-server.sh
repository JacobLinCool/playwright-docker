#!/bin/bash
docker buildx bake --push --set "*.platform=linux/arm64/v8,linux/amd64" chromium-server firefox-server webkit-server chrome-server msedge-server chromium-light-server
