<#
.SYNOPSIS
    Prevents camera access from lock screen to meet STIG WN11-CC-000005 requirements.
.DESCRIPTION
    Disables the ability to access the camera from the Windows lock screen.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000005
#>

# Registry path for personalization policies
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"

try {
    Write-Host "Disabling camera access from lock screen..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Prevent enabling lock screen camera
    Set-ItemProperty -Path $RegistryPath -Name "NoLockScreenCamera" -Value 1 -Type DWord
    
    # Also disable camera access via privacy settings
    $PrivacyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"
    if (!(Test-Path $PrivacyPath)) {
        New-Item -Path $PrivacyPath -Force | Out-Null
        Write-Host "Created privacy registry path: $PrivacyPath" -ForegroundColor Cyan
    }
    
    # Disable camera access for apps above lock screen
    Set-ItemProperty -Path $PrivacyPath -Name "LetAppsAccessCamera_UserInControlOfTheseApps" -Value "Force Deny" -Type String
    
    # Verify the settings were applied
    $CameraSetting = Get-ItemProperty -Path $RegistryPath -Name "NoLockScreenCamera" -ErrorAction SilentlyContinue
    
    if ($CameraSetting.NoLockScreenCamera -eq 1) {
        Write-Host "✓ Lock screen camera access successfully disabled" -ForegroundColor Green
        Write-Host "✓ Camera cannot be accessed from lock screen" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000005 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable lock screen camera access" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring camera access settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Camera access from lock screen has been disabled for security." -ForegroundColor Green