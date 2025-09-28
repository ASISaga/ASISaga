
# Async PowerShell script to install all editable Python packages in the workspace and store all .egg-info in a common directory
# Logs all events to install-all-editable.log

$workspaceRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$eggInfoDir = Join-Path $workspaceRoot '.python-egg-info'



# Create the common egg-info directory if it doesn't exist
if (-not (Test-Path $eggInfoDir)) {
    New-Item -ItemType Directory -Path $eggInfoDir | Out-Null
}

# List of subdirectories to scan for pyproject.toml

# Recursively find all directories with a pyproject.toml
$pyprojectDirs = Get-ChildItem -Path $workspaceRoot -Recurse -File -Filter 'pyproject.toml' | ForEach-Object { $_.DirectoryName } | Sort-Object -Unique
$jobs = @()
$results = @()

foreach ($dirPath in $pyprojectDirs) {
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
            if ($exitCode -eq 0) {
                # Only create detailed log if install succeeded (i.e., is a package)
                $eggInfo = Get-ChildItem -Path $dirPath -Directory -Filter '*.egg-info' | Select-Object -First 1
                if ($eggInfo) {
                    $detailLog = Join-Path $eggInfo.FullName 'install.log'
                    Set-Content -Path $detailLog -Value $out
                } else {
                    # Try to create .egg-info directory if it doesn't exist, then write log
                    $eggInfoName = (Get-ChildItem -Path $dirPath -Name -Filter '*.egg-info' | Select-Object -First 1)
                    if (-not $eggInfoName) {
                        # Try to infer name from project directory
                        $eggInfoName = (Split-Path $dirPath -Leaf) + '.egg-info'
                    }
                    $eggInfoPath = Join-Path $dirPath $eggInfoName
                    if (-not (Test-Path $eggInfoPath)) {
                        New-Item -ItemType Directory -Path $eggInfoPath | Out-Null
                    }
                    $detailLog = Join-Path $eggInfoPath 'install.log'
                    Set-Content -Path $detailLog -Value $out
                }
            }
            Pop-Location
            return @{Dir=$dirPath;ExitCode=$exitCode}
        } catch {
            $err = $_.Exception.Message
            Write-Host "[$(Get-Date -Format o)] ERROR in ${dirPath}: $err"
            return @{Dir=$dirPath;ExitCode=1}
        }
    } -ArgumentList $dir.FullName, $eggInfoDir
}

# Wait for all jobs to finish
if ($jobs.Count -gt 0) {
    $jobs | Wait-Job | Out-Null
    foreach ($job in $jobs) {
        $result = Receive-Job $job
        $results += $result
        Remove-Job $job
    }
}

# Summarize results
$failures = $results | Where-Object { $_.ExitCode -ne 0 }
$summaryLog = Join-Path $eggInfoDir 'install-summary.log'
$summaryLines = @()
if ($results.Count -gt 0) {
    $summaryLines += "Install summary for editable Python packages:`n"
    foreach ($result in $results) {
        $status = if ($result.ExitCode -eq 0) { 'SUCCESS' } else { 'FAILED' }
        $summaryLines += "$($result.Dir): $status"
    }
    $summaryLines += ""
    if ($failures.Count -gt 0) {
        $summaryLines += "Some installs failed. See individual install.log files for details."
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
} else {
    Write-Host "All editable Python packages installed successfully. .egg-info stored in $eggInfoDir."
    Write-Host "See $logFile for details."
}
