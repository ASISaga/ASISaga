
# Async PowerShell script to install all editable Python packages in the workspace and store all .egg-info in a common directory
# Logs all events to install-all-editable.log

$workspaceRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$eggInfoDir = Join-Path $workspaceRoot '.python-egg-info'



# Create the common egg-info directory if it doesn't exist
if (-not (Test-Path $eggInfoDir)) {
    New-Item -ItemType Directory -Path $eggInfoDir | Out-Null
}

# List of subdirectories to scan for pyproject.toml
$subdirs = Get-ChildItem -Path $workspaceRoot -Directory
$jobs = @()
$results = @()

foreach ($dir in $subdirs) {
    $pyproject = Join-Path $dir.FullName 'pyproject.toml'
    if (Test-Path $pyproject) {
        $jobName = "Install_$($dir.Name)"
        Write-Host "[$(Get-Date -Format o)] Starting install for $($dir.Name)"
        $jobs += Start-Job -Name $jobName -ScriptBlock {
            param($dirPath, $eggInfoDir)
            try {
                Push-Location $dirPath
                Write-Host "[$(Get-Date -Format o)] Installing editable package in $dirPath"
                $out = pip install -e . 2>&1
                $exitCode = $LASTEXITCODE
                Write-Host "[$(Get-Date -Format o)] Finished $dirPath with exit code $exitCode"
                # Find .egg-info directory in this package
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
                Pop-Location
                return @{Dir=$dirPath;ExitCode=$exitCode}
            } catch {
                $err = $_.Exception.Message
                Write-Host "[$(Get-Date -Format o)] ERROR in ${dirPath}: $err"
                return @{Dir=$dirPath;ExitCode=1}
            }
        } -ArgumentList $dir.FullName, $eggInfoDir
    }
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
if ($failures.Count -gt 0) {
    Write-Host "Some installs failed. See $logFile for details."
    foreach ($fail in $failures) {
        Write-Host "FAILED: $($fail.Dir)"
    }
    exit 1
} else {
    Write-Host "All editable Python packages installed successfully. .egg-info stored in $eggInfoDir."
    Write-Host "See $logFile for details."
}
