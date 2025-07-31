<#
.SYNOPSIS
    Prevents saving passwords in RDP to meet STIG WN11-CC-000270 requirements.
.DESCRIPTION
    Disables the ability to save passwords in Remote Desktop Connection.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-CC-000270
#>

# Registry path for Terminal Services policies
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"

try {
    Write-Host "Disabling password saving in Remote Desktop..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Disable password saving
    Set-ItemProperty -Path $RegistryPath -Name "DisablePasswordSaving" -Value 1 -Type DWord
    
    # Verify the setting was applied
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "DisablePasswordSaving" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.DisablePasswordSaving -eq 1) {
        Write-Host "✓ RDP password saving successfully disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000270 requirement satisfied" -ForegroundColor Green
        Write-Host "✓ Users cannot save credentials in RDP client" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable RDP password saving" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring RDP settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: Users must enter credentials for each RDP session." -ForegroundColor Yellow