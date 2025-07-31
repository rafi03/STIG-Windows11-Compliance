<#
.SYNOPSIS
    Turns off Microsoft consumer experiences to meet STIG WN11-CC-000197 requirements.
.DESCRIPTION
    Disables Microsoft consumer experiences that suggest third-party content and apps.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000197
#>

# Registry path for Cloud Content policies
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"

try {
    Write-Host "Turning off Microsoft consumer experiences..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Disable Windows Consumer Features
    Set-ItemProperty -Path $RegistryPath -Name "DisableWindowsConsumerFeatures" -Value 1 -Type DWord
    
    # Also disable third-party suggestions
    Set-ItemProperty -Path $RegistryPath -Name "DisableThirdPartySuggestions" -Value 1 -Type DWord
    
    # Disable consumer account state content
    Set-ItemProperty -Path $RegistryPath -Name "DisableConsumerAccountStateContent" -Value 1 -Type DWord
    
    # Verify the settings were applied
    $Setting1 = Get-ItemProperty -Path $RegistryPath -Name "DisableWindowsConsumerFeatures" -ErrorAction SilentlyContinue
    $Setting2 = Get-ItemProperty -Path $RegistryPath -Name "DisableThirdPartySuggestions" -ErrorAction SilentlyContinue
    
    if ($Setting1.DisableWindowsConsumerFeatures -eq 1 -and $Setting2.DisableThirdPartySuggestions -eq 1) {
        Write-Host "✓ Microsoft consumer experiences successfully disabled" -ForegroundColor Green
        Write-Host "✓ Third-party suggestions disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000197 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable consumer experiences" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring consumer experience settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "System will no longer suggest third-party apps or content." -ForegroundColor Green