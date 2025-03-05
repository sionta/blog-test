[CmdletBinding()]
param (
    [ValidateSet('build', 'watch')]
    [string]$Mode = 'build',
    [string]$Source = 'src',
    [string]$Output = '_site',
    [object]$Config = '_config.yml,_config.dev.yml'
)

Set-StrictMode -Off
Set-Location "$PSScriptRoot/.."

$env:BUILD_DIR = $Output

# Convert comma-separated config files into an array
if ($Config -is [string]) {
    $Config = $Config -split ','
}

foreach ($file in $Config) {
    if (-not (Test-Path -Path $file -PathType Leaf)) {
        Write-Error "Config file '$file' not found."
        exit 1
    }
}

# Join config files for Jekyll
$Config = $Config -join ','

# Jekyll options
$options = @(
    '--source', "$Source",
    '--destination', "$env:BUILD_DIR",
    '--config', "$Config"
)

# Commands list
$commands = @("bundle exec jekyll clean $options")

switch ($Mode) {
    'build' { $commands += "bundle exec jekyll build $options" }
    'watch' { $commands += "bundle exec jekyll serve $options --watch" }
}

$pwsh = (Get-Command pwsh, powershell -ea:0)[0].Source

# Execute commands
foreach ($cmd in $commands) {
    Write-Host "Running: $cmd" -ForegroundColor DarkMagenta
    & $pwsh -nop -c $cmd
}

# Run gulp if mode is build
if ($Mode -eq 'build') {
    Write-Host 'Running: npx gulp' -ForegroundColor Cyan
    & npx gulp
}
