
param (
    [string]$CommitMessage = "Update"
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
        
        # Add all changes including submodules
        git add -A
        
        # Commit with error handling
        $commitOutput = git commit -m $message 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✓ Committed changes" -ForegroundColor Green
            
            # Push with error handling
            $pushOutput = git push 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  ✓ Pushed to remote" -ForegroundColor Green
            } else {
                Write-Host "  ⚠️ Push failed: $pushOutput" -ForegroundColor Yellow
            }
        } else {
            Write-Host "  ⚠️ Commit failed or nothing to commit: $commitOutput" -ForegroundColor Yellow
        }
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