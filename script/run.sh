#!/usr/bin/env bash

set -e          # Exit on error
set -o pipefail # Fail pipeline if any command fails

# Default values
MODE="build"
SOURCE="src"
OUTPUT="_site"
CONFIG="_config.yml,_config.dev.yml"

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
    --mode)
        MODE="$2"
        shift
        ;;
    --source)
        SOURCE="$2"
        shift
        ;;
    --output)
        OUTPUT="$2"
        shift
        ;;
    --config)
        CONFIG="$2"
        shift
        ;;
    *)
        echo "Unknown parameter: $1"
        exit 1
        ;;
    esac
    shift
done

export BUILD_DIR="$OUTPUT"

# Convert comma-separated config files into an array
IFS=',' read -r -a CONFIG_FILES <<<"$CONFIG"

# Check if config files exist
for file in "${CONFIG_FILES[@]}"; do
    if [[ ! -f "$file" ]]; then
        echo "Error: Config file '$file' not found." >&2
        exit 1
    fi
done

# Join config files for Jekyll
CONFIG_JOINED=$(
    IFS=,
    echo "${CONFIG_FILES[*]}"
)

# Jekyll options
OPTIONS=(--source "$SOURCE" --destination "$BUILD_DIR" --config "$CONFIG_JOINED")

# Commands list
COMMANDS=("bundle exec jekyll clean ${OPTIONS[*]}")

if [[ "$MODE" == "build" ]]; then
    COMMANDS+=("bundle exec jekyll build ${OPTIONS[*]}")
elif [[ "$MODE" == "watch" ]]; then
    COMMANDS+=("bundle exec jekyll serve ${OPTIONS[*]} --watch")
fi

# Execute commands
for CMD in "${COMMANDS[@]}"; do
    echo -e "\e[35mRunning: $CMD\e[0m"
    bash -c "$CMD"
done

# Run gulp if mode is build
if [[ "$MODE" == "build" ]]; then
    echo -e "\e[36mRunning: npx gulp\e[0m"
    npx gulp
fi
