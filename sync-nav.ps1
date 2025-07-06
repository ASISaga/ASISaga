# PowerShell script to sync and push nav.yml for all subdomains (from external JSON config)

$configPath = Join-Path $PSScriptRoot 'Website/subdomains.json'
$config = Get-Content $configPath | ConvertFrom-Json
$themeRepo = $config.themeRepo
$subdomains = $config.subdomains

foreach ($sub in $subdomains) {
    Write-Host "Syncing nav.yml for $sub..."
    Copy-Item "Website/$themeRepo/_data/nav.yml" "Website/$sub/_data/nav.yml" -Force
    Push-Location "Website/$sub"
    git add _data/nav.yml
    git commit -m "Update nav.yml from theme" _data/nav.yml
    git push
    Pop-Location
}
