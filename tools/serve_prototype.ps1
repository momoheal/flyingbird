param(
    [int]$Port = 8080
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

Write-Host "http://localhost:$Port/prototype/fb.html"
python -m http.server $Port --bind 127.0.0.1
