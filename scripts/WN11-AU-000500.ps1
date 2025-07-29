<#
.SYNOPSIS
    Configures the Application event log size to meet STIG WN11-AU-000500 requirements.
.DESCRIPTION
    Sets the maximum Application event log size to 32768 KB (32 MB) or greater as required by STIG.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-AU-000500
#>

# Define the minimum required log size in KB
$RequiredSizeKB = 32768

# Registry path for Application event log settings
$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application"

try {
    Write-Host "Configuring Application Event Log size..." -ForegroundColor Yellow
    
    # Set the maximum log file size
    Set-ItemProperty -Path $RegistryPath -Name "MaxSize" -Value $RequiredSizeKB -Type DWord
    
    # Verify the setting was applied
    $CurrentSize = Get-ItemProperty -Path $RegistryPath -Name "MaxSize" -ErrorAction SilentlyContinue
    
    if ($CurrentSize.MaxSize -ge $RequiredSizeKB) {
        Write-Host "✓ Application Event Log size successfully set to $($CurrentSize.MaxSize) KB" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AU-000500 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to set Application Event Log size" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring Application Event Log: $($_.Exception.Message)" -ForegroundColor Red
}