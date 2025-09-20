param (
    [Parameter(Mandatory = $true)]
    [string]$CommitMessage
)

# Store the starting folder (root repo path)
$rootPath = Get-Location

# Find all nested repos (excluding the root .git folder)
$repos = Get-ChildItem -Recurse -Directory -Force -ErrorAction SilentlyContinue |
         Where-Object { $_.Name -eq ".git" -and $_.FullName -ne (Join-Path $rootPath ".git") } |
         Select-Object -ExpandProperty ParentFullName -Unique

# Process nested repos first
foreach ($repoPath in $repos) {
    Write-Host "📂 Processing nested repo: $repoPath ..." -ForegroundColor Cyan
    Set-Location $repoPath

    git add .
    git commit -m $CommitMessage 2>$null
    git push
}

# Finally, process the root repo
Set-Location $rootPath
Write-Host "📂 Processing ROOT repo: $rootPath ..." -ForegroundColor Yellow
git add .
git commit -m $CommitMessage 2>$null
git push

Write-Host "✅ All nested repos and root repo committed and pushed." -ForegroundColor Green