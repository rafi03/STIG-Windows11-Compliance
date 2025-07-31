<#
.SYNOPSIS
    Disables autoplay for all drives to meet STIG WN11-CC-000190 requirements.
.DESCRIPTION
    Turns off AutoPlay for all drives by setting the NoDriveTypeAutoRun value to 255 (0xFF).
    This prevents malicious code from executing automatically from any drive type.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-31
    Version         : 1.1
    STIG-ID         : WN11-CC-000190
#>

# Define the required registry path and value name from the STIG
$RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$ValueName = "NoDriveTypeAutoRun"
$RequiredValue = 255 # 0xFF disables AutoPlay on unknown, removable, CD-ROM, network, and RAM drives

try {
    Write-Host "Disabling AutoPlay for all drives to meet STIG WN11-CC-000190..." -ForegroundColor Yellow

    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }

    # Set the required registry value to disable AutoPlay
    Set-ItemProperty -Path $RegistryPath -Name $ValueName -Value $RequiredValue -Type DWord -Force
    
    # --- Verification ---
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name $ValueName -ErrorAction SilentlyContinue

    if ($CurrentSetting.$ValueName -eq $RequiredValue) {
        Write-Host "--------------------------------------------------------" -ForegroundColor DarkGray
        Write-Host "✓ SUCCESS: AutoPlay successfully disabled for all drives." -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000190 requirement satisfied." -ForegroundColor Green
    } else {
        Write-Host "--------------------------------------------------------" -ForegroundColor DarkGray
        Write-Host "✗ FAILURE: Failed to verify the registry setting." -ForegroundColor Red
        Write-Host "  Please check permissions for path: $RegistryPath" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ FATAL ERROR: An exception occurred. $($_.Exception.Message)" -ForegroundColor Red
}