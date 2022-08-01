#!/bin/sh
docker buildx bake --push --set "*.platform=linux/arm/v7,linux/arm64/v8,linux/amd64"
