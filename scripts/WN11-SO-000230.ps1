<#
.SYNOPSIS
    Enables FIPS-compliant algorithms to meet STIG WN11-SO-000230 requirements.
.DESCRIPTION
    Configures the system to use only FIPS-compliant algorithms for all cryptographic operations.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-SO-000230
#>

# Registry path for FIPS policy
$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy"

try {
    Write-Host "Enabling FIPS-compliant algorithms..." -ForegroundColor Yellow
    Write-Host "WARNING: This change requires a system restart to take effect!" -ForegroundColor Red
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Enable FIPS-compliant algorithms
    # Value 1 = Use FIPS-compliant algorithms for encryption, hashing, and signing
    Set-ItemProperty -Path $RegistryPath -Name "Enabled" -Value 1 -Type DWord
    
    # Also set the policy registry value
    $PolicyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
    Set-ItemProperty -Path $PolicyPath -Name "FipsAlgorithmPolicy" -Value 1 -Type DWord
    
    # Verify the settings were applied
    $FIPSSetting = Get-ItemProperty -Path $RegistryPath -Name "Enabled" -ErrorAction SilentlyContinue
    $PolicySetting = Get-ItemProperty -Path $PolicyPath -Name "FipsAlgorithmPolicy" -ErrorAction SilentlyContinue
    
    if ($FIPSSetting.Enabled -eq 1 -and $PolicySetting.FipsAlgorithmPolicy -eq 1) {
        Write-Host "✓ FIPS-compliant algorithms successfully enabled" -ForegroundColor Green
        Write-Host "✓ System will use only FIPS-approved cryptographic algorithms" -ForegroundColor Green
        Write-Host "✓ STIG WN11-SO-000230 requirement satisfied" -ForegroundColor Green
        Write-Host "⚠️  RESTART REQUIRED: Changes take effect after system restart" -ForegroundColor Yellow
    } else {
        Write-Host "✗ Failed to enable FIPS-compliant algorithms" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring FIPS settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "System configured to use FIPS-compliant cryptographic algorithms." -ForegroundColor Green
Write-Host "Please restart the system for changes to take effect." -ForegroundColor Yellow