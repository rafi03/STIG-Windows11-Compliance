<#
.SYNOPSIS
    Disables 'Always install with elevated privileges' to meet STIG WN11-CC-000315 requirements.
.DESCRIPTION
    Prevents Windows Installer from always using elevated privileges during installations.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000315
#>

# Registry paths for Windows Installer policies (both machine and user)
$MachinePath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"
$UserPath = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Installer"

try {
    Write-Host "Disabling 'Always install with elevated privileges'..." -ForegroundColor Yellow
    
    # Configure machine policy
    if (!(Test-Path $MachinePath)) {
        New-Item -Path $MachinePath -Force | Out-Null
        Write-Host "Created machine registry path: $MachinePath" -ForegroundColor Cyan
    }
    
    # Configure user policy
    if (!(Test-Path $UserPath)) {
        New-Item -Path $UserPath -Force | Out-Null
        Write-Host "Created user registry path: $UserPath" -ForegroundColor Cyan
    }
    
    # Disable elevated privileges for machine installations
    Set-ItemProperty -Path $MachinePath -Name "AlwaysInstallElevated" -Value 0 -Type DWord
    
    # Disable elevated privileges for user installations  
    Set-ItemProperty -Path $UserPath -Name "AlwaysInstallElevated" -Value 0 -Type DWord
    
    # Verify the settings were applied
    $MachineSetting = Get-ItemProperty -Path $MachinePath -Name "AlwaysInstallElevated" -ErrorAction SilentlyContinue
    $UserSetting = Get-ItemProperty -Path $UserPath -Name "AlwaysInstallElevated" -ErrorAction SilentlyContinue
    
    if ($MachineSetting.AlwaysInstallElevated -eq 0 -and $UserSetting.AlwaysInstallElevated -eq 0) {
        Write-Host "✓ 'Always install with elevated privileges' successfully disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000315 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable elevated privileges installation" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring installer privilege settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Windows Installer will no longer automatically use elevated privileges." -ForegroundColor Green