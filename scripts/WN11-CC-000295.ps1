<#
.SYNOPSIS
    Prevents RSS feed attachments from being downloaded to meet STIG WN11-CC-000295 requirements.
.DESCRIPTION
    Configures RSS Feeds to prevent downloading of enclosures/attachments for security.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000295
#>

# Registry path for RSS Feeds policies
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Feeds"

try {
    Write-Host "Preventing RSS feed attachments from downloading..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Prevent downloading of RSS feed enclosures/attachments
    Set-ItemProperty -Path $RegistryPath -Name "DisableEnclosureDownload" -Value 1 -Type DWord
    
    # Verify the setting was applied
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "DisableEnclosureDownload" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.DisableEnclosureDownload -eq 1) {
        Write-Host "✓ RSS feed attachments successfully disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000295 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable RSS feed attachments" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring RSS feed settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "RSS feeds will no longer automatically download attachments." -ForegroundColor Green