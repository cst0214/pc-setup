# PC Setup - installs Python 3.13, uv and FFmpeg for Claude Desktop + Windows-MCP
# Run in PowerShell:
#   irm https://raw.githubusercontent.com/cst0214/pc-setup/main/setup.ps1 | iex

$ErrorActionPreference = 'Continue'

function Write-Step($text) {
    Write-Host ''
    Write-Host '==========================================' -ForegroundColor Cyan
    Write-Host " $text" -ForegroundColor Cyan
    Write-Host '==========================================' -ForegroundColor Cyan
}

function Update-SessionPath {
    $machine = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $user    = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$machine;$user"
}

function Test-Command($name) {
    return [bool](Get-Command $name -ErrorAction SilentlyContinue |
        Where-Object { $_.Source -notlike '*WindowsApps*' })
}

function Install-Package($id, $label, $command) {
    Write-Step "Installing $label"
    if (Test-Command $command) {
        Write-Host "$label is already installed - skipping." -ForegroundColor Green
        return
    }
    winget install --id $id -e --silent --accept-source-agreements --accept-package-agreements
    Update-SessionPath
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host 'winget was not found. Install "App Installer" from the Microsoft Store, then run this again.' -ForegroundColor Red
    return
}

Install-Package 'Python.Python.3.13' 'Python 3.13' 'python'
Install-Package 'astral-sh.uv'       'uv'          'uv'
Install-Package 'Gyan.FFmpeg'        'FFmpeg'      'ffmpeg'

Update-SessionPath

Write-Step 'Results'
foreach ($cmd in @(
    @{ Name = 'Python'; Run = { python --version } },
    @{ Name = 'uv';     Run = { uv --version } },
    @{ Name = 'FFmpeg'; Run = { (ffmpeg -version | Select-Object -First 1) } }
)) {
    try {
        $out = & $cmd.Run 2>&1
        Write-Host ("[OK]   {0,-7} {1}" -f $cmd.Name, $out) -ForegroundColor Green
    } catch {
        Write-Host ("[FAIL] {0,-7} not found - open a new window and run this again" -f $cmd.Name) -ForegroundColor Yellow
    }
}

Write-Host ''
Write-Host 'Next steps:' -ForegroundColor Cyan
Write-Host '  1. Quit Claude Desktop fully (tray icon > Quit), then reopen it.'
Write-Host '  2. Settings > Extensions > search "Windows-MCP" > Install.'
Write-Host ''
