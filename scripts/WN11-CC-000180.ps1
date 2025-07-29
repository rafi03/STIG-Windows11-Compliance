<#
.SYNOPSIS
    Disables autoplay for non-volume devices to meet STIG WN11-CC-000180 requirements.
.DESCRIPTION
    Prevents autoplay for non-volume devices (Media Transfer Protocol devices) to prevent malicious code execution.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000180
#>

# Registry path for AutoPlay policies
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"

try {
    Write-Host "Disabling autoplay for non-volume devices..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Disable autoplay for non-volume devices
    Set-ItemProperty -Path $RegistryPath -Name "NoAutoplayfornonVolume" -Value 1 -Type DWord
    
    # Verify the setting was applied
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "NoAutoplayfornonVolume" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.NoAutoplayfornonVolume -eq 1) {
        Write-Host "✓ Autoplay for non-volume devices successfully disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000180 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable autoplay for non-volume devices" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring autoplay settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Note: A system restart may be required for changes to take full effect." -ForegroundColor Yellow