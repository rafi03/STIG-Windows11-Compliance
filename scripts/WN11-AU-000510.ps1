<#
.SYNOPSIS
    Configures the System event log size to meet STIG WN11-AU-000510 requirements.
.DESCRIPTION
    Sets the maximum System event log size to 32768 KB (32 MB) as required by STIG.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.1
    STIG-ID         : WN11-AU-000510
#>

# Define the minimum required log size in KB
$RequiredSizeKB = 32768

# Correct registry path for STIG compliance
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System"

try {
    Write-Host "Configuring System Event Log size (STIG WN11-AU-000510)..." -ForegroundColor Yellow

    # Ensure the registry path exists
    if (-not (Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
    }

    # Set the maximum log file size
    Set-ItemProperty -Path $RegistryPath -Name "MaxSize" -Value $RequiredSizeKB -Type DWord

    # Verify the setting was applied
    $CurrentSize = Get-ItemProperty -Path $RegistryPath -Name "MaxSize" -ErrorAction SilentlyContinue

    if ($CurrentSize.MaxSize -ge $RequiredSizeKB) {
        Write-Host "✓ System Event Log size successfully set to $($CurrentSize.MaxSize) KB" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AU-000510 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to set System Event Log size" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring System Event Log: $($_.Exception.Message)" -ForegroundColor Red
}
