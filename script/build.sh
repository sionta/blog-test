#!/usr/bin/env bash

set -e

cd "$(dirname "$0")/.."

JEKYLL_CONFIG="_config.yml,_config.dev.yml"
JEKYLL_SOURCE="./src"

bundle exec jekyll build \
    --source "$JEKYLL_SOURCE" \
    --config "$JEKYLL_CONFIG"
