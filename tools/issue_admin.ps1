param(
    [ValidateSet('list','new','verify','close')][string]$Action = 'list',
    [string]$Id,
    [string]$Title,
    [ValidateSet('P0','P1','P2','P3')][string]$Priority = 'P2',
    [string]$Verification,
    [string]$RegressionTest
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
$Path = Join-Path $Root 'docs\issues.json'
$items = @()
if (Test-Path -LiteralPath $Path) {
    $raw = Get-Content -Raw -Encoding utf8 $Path
    if ($raw.Trim()) { $items = @(ConvertFrom-Json $raw) }
}
function Save-Issues($value) { $value | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $Path -Encoding utf8 }
switch ($Action) {
    'list' { if ($items.Count -eq 0) { Write-Host 'No issues.' } else { $items | Select-Object id,status,priority,title | Format-Table -AutoSize } }
    'new' {
        if ([string]::IsNullOrWhiteSpace($Title)) { throw '-Title is required' }
        $number = 1
        if ($items.Count -gt 0) { $numbers = $items.id | ForEach-Object { if ($_ -match 'FB-(\d+)') { [int]$Matches[1] } }; if ($numbers) { $number = ($numbers | Measure-Object -Maximum).Maximum + 1 } }
        $entry = [pscustomobject]@{ id=('FB-{0:D4}' -f $number); title=$Title; status='OPEN'; priority=$Priority; first_seen=(Get-Date -Format 'yyyy-MM-dd'); repro_steps=''; expected=''; actual=''; root_cause=''; fix_files=@(); verification=''; verified_at=''; regression_test='' }
        $items += $entry; Save-Issues $items; Write-Host "Created $($entry.id)"
    }
    'verify' {
        $entry = $items | Where-Object id -eq $Id | Select-Object -First 1
        if (-not $entry) { throw "Unknown issue: $Id" }; if ([string]::IsNullOrWhiteSpace($Verification)) { throw '-Verification is required' }
        $entry.status='VERIFIED'; $entry.verification=$Verification; $entry.verified_at=(Get-Date -Format 'yyyy-MM-dd HH:mm'); if ($RegressionTest) { $entry.regression_test=$RegressionTest }; Save-Issues $items; Write-Host "$Id verified"
    }
    'close' {
        $entry = $items | Where-Object id -eq $Id | Select-Object -First 1
        if (-not $entry) { throw "Unknown issue: $Id" }; if ($entry.status -ne 'VERIFIED' -or [string]::IsNullOrWhiteSpace($entry.verification) -or [string]::IsNullOrWhiteSpace($entry.regression_test)) { throw "$Id requires VERIFIED status, verification, and regression_test before close" }
        $entry.status='CLOSED'; Save-Issues $items; Write-Host "$Id closed"
    }
}
