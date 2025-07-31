<#
.SYNOPSIS
    Turns off toast notifications on lock screen to meet STIG WN11-UC-000015 requirements.
.DESCRIPTION
    Disables toast notifications from appearing on the lock screen to protect sensitive information.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-UC-000015
#>

# Primary registry path (STIG specifies HKCU)
$UserPolicyPath = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"
# Secondary path for machine-wide enforcement
$MachinePolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"

try {
    Write-Host "Turning off toast notifications on lock screen..." -ForegroundColor Yellow
    
    # Configure for current user (STIG requirement)
    if (!(Test-Path $UserPolicyPath)) {
        New-Item -Path $UserPolicyPath -Force | Out-Null
        Write-Host "Created user policy registry path: $UserPolicyPath" -ForegroundColor Cyan
    }
    
    # Disable toast notifications on lock screen for current user
    Set-ItemProperty -Path $UserPolicyPath -Name "NoToastApplicationNotificationOnLockScreen" -Value 1 -Type DWord
    
    # Also configure machine-wide for comprehensive coverage
    if (!(Test-Path $MachinePolicyPath)) {
        New-Item -Path $MachinePolicyPath -Force | Out-Null
        Write-Host "Created machine policy registry path: $MachinePolicyPath" -ForegroundColor Cyan
    }
    
    Set-ItemProperty -Path $MachinePolicyPath -Name "NoToastApplicationNotificationOnLockScreen" -Value 1 -Type DWord
    
    # Verify the settings were applied
    $UserSetting = Get-ItemProperty -Path $UserPolicyPath -Name "NoToastApplicationNotificationOnLockScreen" -ErrorAction SilentlyContinue
    $MachineSetting = Get-ItemProperty -Path $MachinePolicyPath -Name "NoToastApplicationNotificationOnLockScreen" -ErrorAction SilentlyContinue
    
    if ($UserSetting.NoToastApplicationNotificationOnLockScreen -eq 1) {
        Write-Host "✓ Toast notifications on lock screen successfully disabled for current user" -ForegroundColor Green
        Write-Host "✓ STIG WN11-UC-000015 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable toast notifications for current user" -ForegroundColor Red
    }
    
    if ($MachineSetting.NoToastApplicationNotificationOnLockScreen -eq 1) {
        Write-Host "✓ Toast notifications on lock screen disabled machine-wide" -ForegroundColor Green
    }
    
} catch {
    Write-Host "✗ Error configuring notification settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Lock screen will no longer display toast notifications." -ForegroundColor Green