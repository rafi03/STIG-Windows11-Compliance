<#
.SYNOPSIS
    Configures the Security event log size to meet STIG WN11-AU-000505 requirements.
.DESCRIPTION
    Sets the maximum Security event log size to 1024000 KB (1 GB) as required by STIG.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.1
    STIG-ID         : WN11-AU-000505
#>

# Define the minimum required log size in KB (1 GB)
$RequiredSizeKB = 1024000

# Correct STIG registry path
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security"

try {
    Write-Host "Configuring Security Event Log size (STIG WN11-AU-000505)..." -ForegroundColor Yellow

    # Ensure the path exists
    if (-not (Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
    }

    # Set the maximum log file size
    Set-ItemProperty -Path $RegistryPath -Name "MaxSize" -Value $RequiredSizeKB -Type DWord

    # Verify the setting was applied
    $CurrentSize = Get-ItemProperty -Path $RegistryPath -Name "MaxSize" -ErrorAction SilentlyContinue

    if ($CurrentSize.MaxSize -ge $RequiredSizeKB) {
        Write-Host "✓ Security Event Log size successfully set to $($CurrentSize.MaxSize) KB" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AU-000505 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to set Security Event Log size" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring Security Event Log: $($_.Exception.Message)" -ForegroundColor Red
}
