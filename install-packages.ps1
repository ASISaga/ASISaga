
# Async PowerShell script to install all editable Python packages in the workspace and store all .egg-info in a common directory
# Logs all events to install-all-editable.log

$workspaceRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$eggInfoDir = Join-Path $workspaceRoot '.python-egg-info'



# Create the common egg-info directory if it doesn't exist
if (-not (Test-Path $eggInfoDir)) {
    New-Item -ItemType Directory -Path $eggInfoDir | Out-Null
}

# List of subdirectories to scan for pyproject.toml

# Recursively find all directories with a pyproject.toml, excluding .venv

# Define install waves (each wave: list of directories to install in parallel)
$installWaves = @(
    # Wave 1: PossibilityAgent
    @(Join-Path $workspaceRoot 'RealmOfAgents' 'PossibilityAgent'),
    # Wave 2: LeadershipAgent
    @(Join-Path $workspaceRoot 'RealmOfAgents' 'LeadershipAgent'),
    # Wave 3: BusinessAgent
    @(Join-Path $workspaceRoot 'Boardroom' 'BusinessAgent'),
    # Wave 4: Investor, Founder
    @(
        (Join-Path $workspaceRoot 'Boardroom' 'Investor'),
        (Join-Path $workspaceRoot 'Boardroom' 'Founder')
    ),
    # Wave 5: All other packages (auto-discovered, excluding above)
    @()
)

# Find all pyproject.toml dirs, excluding .venv and already listed above
$allPyprojectDirs = Get-ChildItem -Path $workspaceRoot -Recurse -File -Filter 'pyproject.toml' |
    Where-Object { $_.FullName -notmatch '\.venv' } |
    ForEach-Object { $_.DirectoryName } |
    Sort-Object -Unique

# Add all remaining packages to wave 5
$alreadyListed = $installWaves[0..3] | ForEach-Object { $_ } | Sort-Object -Unique
$wave5 = $allPyprojectDirs | Where-Object { $alreadyListed -notcontains $_ }
$installWaves[4] = $wave5

$results = @()

foreach ($wave in $installWaves) {
    if ($wave.Count -eq 0) { continue }
    $jobs = @()
    foreach ($dirPath in $wave) {
        if (-not (Test-Path $dirPath)) { continue }
        $dir = Get-Item $dirPath
        $jobName = "Install_$($dir.Name)"
        Write-Host "[$(Get-Date -Format o)] Attempting pip install -e . in $($dir.FullName)"
        $jobs += Start-Job -Name $jobName -ScriptBlock {
            param($dirPath, $eggInfoDir)
            try {
                Push-Location $dirPath
                Write-Host "[$(Get-Date -Format o)] Installing editable package in $dirPath"
                $out = pip install -e . 2>&1
                $exitCode = $LASTEXITCODE
                Write-Host "[$(Get-Date -Format o)] Finished $dirPath with exit code $exitCode"
                $repoName = Split-Path $dirPath -Leaf
                $logFile = Join-Path $eggInfoDir ("$repoName.log")
                Set-Content -Path $logFile -Value $out
                Pop-Location
                return @{Dir=$dirPath;ExitCode=$exitCode}
            } catch {
                $err = $_.Exception.Message
                Write-Host "[$(Get-Date -Format o)] ERROR in ${dirPath}: $err"
                return @{Dir=$dirPath;ExitCode=1}
            }
        } -ArgumentList $dir.FullName, $eggInfoDir
    }
    # Wait for all jobs in this wave to finish
    if ($jobs.Count -gt 0) {
        $jobs | Wait-Job | Out-Null
        foreach ($job in $jobs) {
            $result = Receive-Job $job
            # If install failed, check if it's because it's not a package (no setup/pyproject)
            if ($result.ExitCode -ne 0) {
                $pyprojectPath = Join-Path $result.Dir 'pyproject.toml'
                $isNotPackage = $false
                if (Test-Path $pyprojectPath) {
                    $pyprojectContent = Get-Content $pyprojectPath -Raw
                    if ($pyprojectContent -notmatch '\[project\]') {
                        $isNotPackage = $true
                    } elseif ($pyprojectContent -match 'where\s*=\s*\[\s*"src"\s*\]') {
                        $srcInit = Join-Path $result.Dir 'src\__init__.py'
                        if (-not (Test-Path $srcInit)) {
                            $isNotPackage = $true
                        }
                    } else {
                        $rootInit = Join-Path $result.Dir '__init__.py'
                        if (-not (Test-Path $rootInit)) {
                            $isNotPackage = $true
                        }
                    }
                } else {
                    $isNotPackage = $true
                }
                if ($isNotPackage) {
                    $result.ExitCode = 2  # Mark as 'not a package'
                }
            }
            $results += $result
            Remove-Job $job
        }
    }
}

# Summarize results
$failures = $results | Where-Object { $_.ExitCode -eq 1 }
$notPackages = $results | Where-Object { $_.ExitCode -eq 2 }
$summaryLog = Join-Path $eggInfoDir 'install-summary.log'
$summaryLines = @()
if ($results.Count -gt 0) {
    $summaryLines += "Install summary for editable Python packages:`n"
    foreach ($result in $results) {
        $status = if ($result.ExitCode -eq 0) { 'SUCCESS' } elseif ($result.ExitCode -eq 2) { 'NOT A PACKAGE' } else { 'FAILED' }
        $repoName = Split-Path $result.Dir -Leaf
        $logPath = Join-Path $eggInfoDir ("$repoName.log")
        $summaryLines += "$($result.Dir): $status (log: $logPath)"
    }
    $summaryLines += ""
    if ($failures.Count -gt 0) {
        $summaryLines += "Some installs failed. See individual install.log files for details."
    } elseif ($notPackages.Count -gt 0) {
        $summaryLines += "Some directories are not Python packages."
    } else {
        $summaryLines += "All editable Python packages installed successfully."
    }
    Set-Content -Path $summaryLog -Value $summaryLines
    Write-Host "Install summary written to $summaryLog"
}
if ($failures.Count -gt 0) {
    Write-Host "Some installs failed. See $logFile for details."
    foreach ($fail in $failures) {
        Write-Host "FAILED: $($fail.Dir)"
    }
    # Do not exit with error code, just summarize
} elseif ($notPackages.Count -gt 0) {
    Write-Host "Some directories are not Python packages."
    Write-Host "See $summaryLog for details."
} else {
    Write-Host "All editable Python packages installed successfully. .egg-info stored in $eggInfoDir."
    Write-Host "See $logFile for details."
}
