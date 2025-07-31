<#
.SYNOPSIS
    Configures RDP to always prompt for password to meet STIG WN11-CC-000280 requirements.
.DESCRIPTION
    Forces Remote Desktop to always request credentials upon connection.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-CC-000280
#>

# Registry path for Terminal Services policies
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"

try {
    Write-Host "Configuring RDP to always prompt for password..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Force password prompt
    Set-ItemProperty -Path $RegistryPath -Name "fPromptForPassword" -Value 1 -Type DWord
    
    # Verify the setting was applied
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "fPromptForPassword" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.fPromptForPassword -eq 1) {
        Write-Host "✓ RDP will always prompt for password" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000280 requirement satisfied" -ForegroundColor Green
        Write-Host "✓ Enhanced security for remote connections" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to configure RDP password prompt" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring RDP settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: RDP connections will always require password entry." -ForegroundColor Yellow