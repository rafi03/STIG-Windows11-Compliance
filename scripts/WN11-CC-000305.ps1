<#
.SYNOPSIS
    Disables indexing of encrypted files to meet STIG WN11-CC-000305 requirements.
.DESCRIPTION
    Turns off indexing of encrypted files to prevent potential exposure of sensitive data.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000305
#>

# Registry path for Search policies
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"

try {
    Write-Host "Disabling indexing of encrypted files..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Disable indexing of encrypted files
    # Value 0 = Do not allow indexing of encrypted files
    Set-ItemProperty -Path $RegistryPath -Name "AllowIndexingEncryptedStoresOrItems" -Value 0 -Type DWord
    
    # Verify the setting was applied
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "AllowIndexingEncryptedStoresOrItems" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.AllowIndexingEncryptedStoresOrItems -eq 0) {
        Write-Host "✓ Indexing of encrypted files successfully disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000305 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable indexing of encrypted files" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring search indexing settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Encrypted files will no longer be indexed by Windows Search." -ForegroundColor Green