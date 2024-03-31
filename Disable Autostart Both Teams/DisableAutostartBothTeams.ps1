<#
Author:  Ed Boon
Script:  DisableAutostartBothTeams.ps1
Description: Prevent Microsoft Classic and NEW Teams to start automatically.
The script must run in USER context

Release notes:
Version 1.0: 2024-02-22 - Original published version.

The script is provided "AS IS" with no warranties.
#>

Start-Transcript -Path "$env:TEMP\DisableAutostartBothTeams.log" | Out-Null

# Remove Run registry entry to disable auto-start of Classic Teams
$runKeyPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$runPropertyName = "com.squirrel.Teams.Teams"

$runProperty = Get-ItemProperty -Path $runKeyPath -Name $runPropertyName -ErrorAction SilentlyContinue
if ($runProperty -ne $null) {
    Remove-ItemProperty -Path $runKeyPath -Name $runPropertyName -ErrorAction SilentlyContinue
    Write-Host "Autostart of Classic Teams has been Disabled"
} else {
    Write-Host "Autostart Classic Teams was already diasabled or not there at all"
}

# Modify State Key to disable New Teams
$hpath = "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\MSTeams_8wekyb3d8bbwe\TeamsTfwStartupTask"

if (Test-Path $hpath) {
    # Modify State
    Set-ItemProperty -Path $hpath -Name "State" -Value "0"

    # Modify LastDisabledTime
    $epoch = (Get-Date -Date ((Get-Date).DateTime) -UFormat %s)
    Set-ItemProperty -Path $hpath -Name "LastDisabledTime" -Value $epoch

    Write-Host "Autostart NEW Teams has been Disabled"
} else {
    Write-Host "NEW Teams is not found"
}

Write-Host "Disable Autostart of Teams configuration completed."


Stop-Transcript -Verbose
