Write-Host "=== Starting dependency repair ===" -ForegroundColor Cyan

Write-Host "Checking for broken dependencies..." -ForegroundColor Yellow
$pipCheckResult = pip check
Write-Output $pipCheckResult

$brokenPackages = $pipCheckResult |
    ForEach-Object {
        if ($_ -match "^(?<pkg>[A-Za-z0-9._-]+) ") { $matches['pkg'] }
    } |
    Sort-Object -Unique

if ($brokenPackages.Count -eq 0) {
    Write-Host "No issues found — all packages are in harmony." -ForegroundColor Green
} else {
    foreach ($pkg in $brokenPackages) {
        Write-Host "Upgrading $pkg to latest compatible version..." -ForegroundColor Magenta
        pip install --upgrade $pkg
    }
}

Write-Host "=== Dependency repair complete ===" -ForegroundColor Cyan