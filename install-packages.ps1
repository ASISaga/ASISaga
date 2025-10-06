
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


# Define install waves (all at once)
$installWaves = @(
    # Wave 1: PossibilityAgent
    @(Join-Path $workspaceRoot 'RealmOfAgents' 'PossibilityAgent'),
    # Wave 2: LeadershipAgent
    @(Join-Path $workspaceRoot 'RealmOfAgents' 'LeadershipAgent'),
    # Wave 3: BusinessAgent
    @(Join-Path $workspaceRoot 'Boardroom' 'BusinessAgent'),
    # Wave 4: Investor, Founder, and all C-Suite packages (single pip command)
    'WAVE4_SINGLE_PIP',
    # Wave 5: AgentOperatingSystem only
    @((Join-Path $workspaceRoot 'AgentOperatingSystem'))
)



$results = @()

# --- Pre-checks for environment ---
# 1. Check for active virtual environment
if (-not $env:VIRTUAL_ENV) {
    Write-Host "[WARN] No Python virtual environment detected. It is recommended to activate a venv before installing packages."
}
# 2. Check pip version
$pipVersion = pip --version 2>$null
if ($pipVersion -match 'pip (\d+\.\d+)') {
    $ver = [double]$Matches[1]
    if ($ver -lt 23) {
        Write-Host "[WARN] pip version is less than 23. Editable installs with pyproject.toml require pip >= 23."
    }
}

foreach ($wave in $installWaves) {
    $dirsToCheck = @()
    if ($wave -eq 'WAVE4_SINGLE_PIP') {
        $dirsToCheck = @(
            (Join-Path $workspaceRoot 'Boardroom' 'Investor'),
            (Join-Path $workspaceRoot 'Boardroom' 'Founder'),
            (Join-Path $workspaceRoot 'Boardroom' 'C-Suite' 'CEO'),
            (Join-Path $workspaceRoot 'Boardroom' 'C-Suite' 'CFO'),
            (Join-Path $workspaceRoot 'Boardroom' 'C-Suite' 'CHRO'),
            (Join-Path $workspaceRoot 'Boardroom' 'C-Suite' 'CMO'),
            (Join-Path $workspaceRoot 'Boardroom' 'C-Suite' 'COO'),
            (Join-Path $workspaceRoot 'Boardroom' 'C-Suite' 'CSO'),
            (Join-Path $workspaceRoot 'Boardroom' 'C-Suite' 'CTO')
        )
    } else {
        $dirsToCheck = $wave
    }
    $validDirs = @()
    foreach ($dirPath in $dirsToCheck) {
        $repoName = Split-Path $dirPath -Leaf
        $logFile = Join-Path $eggInfoDir ("$repoName.precheck.log")
        $precheckErrors = @()
        if (-not (Test-Path $dirPath)) {
            $precheckErrors += "[ERROR] Directory missing: $dirPath"
        } elseif (-not (Test-Path (Join-Path $dirPath 'pyproject.toml'))) {
            $precheckErrors += "[ERROR] pyproject.toml missing in $dirPath"
        } else {
            $pyproject = Get-Content (Join-Path $dirPath 'pyproject.toml') -Raw
            if ($pyproject.Length -eq 0) {
                $precheckErrors += "[ERROR] pyproject.toml is empty in $dirPath"
            } elseif ($pyproject -notmatch '\[project\]') {
                $precheckErrors += "[ERROR] pyproject.toml missing [project] section in $dirPath"
            } elseif ($pyproject -notmatch 'name\s*=') {
                $precheckErrors += "[ERROR] pyproject.toml missing name field in $dirPath"
            } elseif ($pyproject -notmatch 'version\s*=') {
                $precheckErrors += "[ERROR] pyproject.toml missing version field in $dirPath"
            }
            $srcDir = Join-Path $dirPath 'src'
            if (-not (Test-Path $srcDir)) {
                $precheckErrors += "[ERROR] src directory missing in $dirPath"
            }
        }
        # Check write permissions
        try {
            $testFile = Join-Path $eggInfoDir ("testwrite-$repoName.txt")
            Set-Content -Path $testFile -Value 'test' -ErrorAction Stop
            Remove-Item $testFile -ErrorAction SilentlyContinue
        } catch {
            $precheckErrors += "[ERROR] No write permission to $eggInfoDir for $repoName"
        }
        # Check for conflicting install
        $pkgName = $null
        if ((Test-Path (Join-Path $dirPath 'pyproject.toml'))) {
            $pyproject = Get-Content (Join-Path $dirPath 'pyproject.toml') -Raw
            if ($pyproject -match 'name\s*=\s*"([^"]+)"') {
                $pkgName = $Matches[1]
            }
        }
        if ($pkgName) {
            $pipShow = pip show $pkgName 2>$null
            if ($pipShow) {
                $precheckErrors += "[WARN] $pkgName already installed in environment."
            }
        }
        if ($precheckErrors.Count -gt 0) {
            $precheckErrors | Set-Content -Path $logFile
            $precheckErrors | ForEach-Object { Write-Host $_ }
        } else {
            $validDirs += $dirPath
        }
    }
    if ($validDirs.Count -eq 0) {
        Write-Host "[WARN] No valid packages found for this wave, skipping pip install."
        continue
    }
    if ($wave -eq 'WAVE4_SINGLE_PIP') {
        $pipArgs = $validDirs | ForEach-Object { "-e `"$_`"" } | Join-String " "
        $logFile = Join-Path $eggInfoDir 'wave4-single-pip.log'
        Write-Host "[$(Get-Date -Format o)] Installing all wave 4 packages in a single pip command (verbose mode)..."
        $cmd = "pip install -vvv $pipArgs"
        Write-Host "Running: $cmd"
        $out = Invoke-Expression $cmd 2>&1
        Set-Content -Path $logFile -Value $out
        $exitCode = $LASTEXITCODE
        foreach ($dir in $validDirs) {
            $results += @{Dir=$dir;ExitCode=$exitCode}
        }
        continue
    }
    foreach ($dirPath in $validDirs) {
        $repoName = Split-Path $dirPath -Leaf
        $logFile = Join-Path $eggInfoDir ("$repoName.log")
        Write-Host "[$(Get-Date -Format o)] Installing $dirPath as editable package (verbose mode)..."
        $cmd = "pip install -vvv -e `"$dirPath`""
        Write-Host "Running: $cmd"
        $out = Invoke-Expression $cmd 2>&1
        Set-Content -Path $logFile -Value $out
        $exitCode = $LASTEXITCODE
        $results += @{Dir=$dirPath;ExitCode=$exitCode}
        Start-Sleep -Seconds 1
    }
    # ...existing code...
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
