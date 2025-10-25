
param (
    [string]$CommitMessage = "Update"
)

# Store the starting folder (root repo path)
$rootPath = Get-Location

# Find all nested repos - both regular repos (.git folder) and submodules (.git file)
$repos = Get-ChildItem -Recurse -Force -ErrorAction SilentlyContinue |
         Where-Object { 
             ($_.Name -eq ".git" -and $_.FullName -ne (Join-Path $rootPath ".git")) -or
             ($_.Name -eq ".git" -and $_.PSIsContainer -eq $false)  # .git file (submodule)
         } |
         ForEach-Object { 
             if ($_.PSIsContainer) {
                 # Regular .git folder
                 Split-Path -Parent $_.FullName
             } else {
                 # .git file (submodule)
                 Split-Path -Parent $_.FullName
             }
         } |
         Sort-Object -Unique

# Also check for submodules using git submodule
try {
    $gitSubmodules = git config --file .gitmodules --get-regexp path | 
                     ForEach-Object { 
                         $parts = $_ -split '\s+'
                         if ($parts.Length -ge 2) {
                             Join-Path $rootPath $parts[1]
                         }
                     }
    if ($gitSubmodules) {
        $repos = ($repos + $gitSubmodules) | Sort-Object -Unique
    }
} catch {
    # No submodules or error reading .gitmodules
}

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