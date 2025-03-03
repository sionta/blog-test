#!/usr/bin/env bash

set -e

cd "$(dirname "$0")/.."

JEKYLL_CONFIG="_config.yml,_config.dev.yml"
JEKYLL_SOURCE="./src"

bundle exec jekyll clean \
    --source "$JEKYLL_SOURCE" \
    --config "$JEKYLL_CONFIG"

bundle exec jekyll serve \
    --source "$JEKYLL_SOURCE" \
    --config "$JEKYLL_CONFIG" \
    --watch
