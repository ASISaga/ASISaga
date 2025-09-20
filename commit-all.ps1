param (
    [Parameter(Mandatory = $true)]
    [string]$CommitMessage
)

# Store the starting folder (root repo path)
$rootPath = Get-Location

# Find all nested repos (excluding the root .git folder)
$repos = Get-ChildItem -Recurse -Directory -Force -ErrorAction SilentlyContinue |
         Where-Object { $_.Name -eq ".git" -and $_.FullName -ne (Join-Path $rootPath ".git") } |
         ForEach-Object { Split-Path -Parent $_.FullName } |
         Sort-Object -Unique

function Commit-And-Push($path, $message) {
    Set-Location $path
    # Check if repo is dirty (has changes)
    $status = git status --porcelain
    if (-not [string]::IsNullOrWhiteSpace($status)) {
        Write-Host "📂 Processing repo: $path" -ForegroundColor Cyan
        git add .
        git commit -m $message
        git push
    }
    else {
        Write-Host "✔️ Clean repo, skipping: $path" -ForegroundColor DarkGray
    }
}

# Process nested repos first
foreach ($repoPath in $repos) {
    Commit-And-Push $repoPath $CommitMessage
}

# Finally, process the root repo
Commit-And-Push $rootPath $CommitMessage

# Return to root
Set-Location $rootPath

Write-Host "✅ All dirty repos committed and pushed. Clean repos skipped." -ForegroundColor Green