#!/usr/bin/env bash

IMAGE_NAME=pschmitt/merge-intervals

cd "$(cd "$(dirname "$0")" >/dev/null 2>&1; pwd -P)" || exit 9

docker build -t "$IMAGE_NAME" .
