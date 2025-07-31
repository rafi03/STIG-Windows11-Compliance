<#
.SYNOPSIS
    Prevents users from changing installation options to meet STIG WN11-CC-000310 requirements.
.DESCRIPTION
    Disables user control over installation options to maintain administrative control.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000310
#>

# Registry path for Windows Installer policies
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"

try {
    Write-Host "Preventing users from changing installation options..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Disable user control over installs
    # Value 0 = Do not allow user control over installs
    Set-ItemProperty -Path $RegistryPath -Name "EnableUserControl" -Value 0 -Type DWord
    
    # Verify the setting was applied
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "EnableUserControl" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.EnableUserControl -eq 0) {
        Write-Host "✓ User control over installations successfully disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000310 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable user control over installations" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring installation control settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Users can no longer modify installation options." -ForegroundColor Green