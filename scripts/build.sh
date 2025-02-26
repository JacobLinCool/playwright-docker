#!/bin/bash
docker buildx bake --push --set "*.platform=linux/arm64/v8,linux/amd64" base chromium firefox webkit chrome msedge all
