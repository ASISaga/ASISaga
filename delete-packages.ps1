# Delete-Agent-EggInfo.ps1
# Deletes *.egg-info directories from each agent's src/<AgentName>/ and top-level agent directory
# Usage: Run from the ASISaga root directory

$workspaceRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$eggInfoDir = Join-Path $workspaceRoot '.python-egg-info'

# Create the common egg-info directory if it doesn't exist
if (-not (Test-Path $eggInfoDir)) {
    New-Item -ItemType Directory -Path $eggInfoDir | Out-Null
}

$logFile = Join-Path $eggInfoDir 'delete-egginfo.log'
$logLines = @()
$logLines += "Egg-info cleanup started at $(Get-Date -Format o)"

$agentDirs = Get-ChildItem -Directory | Where-Object { 
    Test-Path (Join-Path $_.FullName 'pyproject.toml')
}

foreach ($agent in $agentDirs) {
    $srcDir = Join-Path $agent.FullName 'src'
    if (Test-Path $srcDir) {
        $pkgDirs = Get-ChildItem -Directory -Path $srcDir -ErrorAction SilentlyContinue
        foreach ($pkg in $pkgDirs) {
            $eggInfo = Join-Path $pkg.FullName "$($pkg.Name).egg-info"
            if (Test-Path $eggInfo) {
                $msg = "Deleting $eggInfo"
                Write-Host $msg
                $logLines += $msg
                try {
                    Remove-Item -Recurse -Force $eggInfo
                } catch {
                    $err = $_.Exception.Message
                    $logLines += "ERROR deleting $($eggInfo): $($err)"
                }
            }
        }
    }
    $topEggInfo = Join-Path $agent.FullName "$($agent.Name).egg-info"
    if (Test-Path $topEggInfo) {
        $msg = "Deleting $topEggInfo"
        Write-Host $msg
        $logLines += $msg
        try {
            Remove-Item -Recurse -Force $topEggInfo
        } catch {
            $err = $_.Exception.Message
            $logLines += "ERROR deleting $($topEggInfo): $($err)"
        }
    }
}
$logLines += "Egg-info cleanup complete at $(Get-Date -Format o)"
Set-Content -Path $logFile -Value $logLines
Write-Host "Egg-info cleanup complete. Log written to $logFile."
