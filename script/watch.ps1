Set-StrictMode -Off

Set-Location "$PSScriptRoot/.."

$CONFIG_FILES = '_config.yml,_config.dev.yml'
$SOURCE_DIR = 'src'
$BUILD_DIR = '_site'
$options = (
    '--source', "$SOURCE_DIR",
    '--destination', "$BUILD_DIR",
    '--config', "$CONFIG_FILES"
)

'clean', 'serve' | ForEach-Object {
    $commands = "bundle exec jekyll $_ $options"

    if ($_ -eq 'serve') {
        $commands = "$commands --watch"
    }

    Write-Host $commands -ForegroundColor DarkMagenta
    Invoke-Expression -Command $commands
}
