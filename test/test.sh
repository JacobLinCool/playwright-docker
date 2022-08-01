#!/bin/sh
cd $(dirname $0)
docker run --rm -v "$(pwd):/test" -w "/test" jacoblincool/playwright:all npm test
