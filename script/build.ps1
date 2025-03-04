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

'clean', 'build' | ForEach-Object {
    $commands = "bundle exec jekyll $_ $options"
    Write-Host $commands -ForegroundColor DarkMagenta
    Invoke-Expression -Command $commands
    if ($_ -eq 'build') { npx gulp }
}
