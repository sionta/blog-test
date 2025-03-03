#Requires -Version 3.0

Set-StrictMode -Off

Set-Location "$PSScriptRoot/.."

$JEKYLL_CONFIG = '_config.yml,_config.dev.yml'
$JEKYLL_SOURCE = './src'

bundle exec jekyll clean `
    --source "$JEKYLL_SOURCE" `
    --config "$JEKYLL_CONFIG"

bundle exec jekyll serve `
    --source "$JEKYLL_SOURCE" `
    --config "$JEKYLL_CONFIG" `
    --watch
