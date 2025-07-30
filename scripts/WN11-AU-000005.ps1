<#
.SYNOPSIS
    Enables auditing of credential validation failures to meet STIG WN11-AU-000005 requirements.
.DESCRIPTION
    Configures system to log all failed authentication attempts.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-AU-000005
#>

try {
    Write-Host "Enabling audit of credential validation failures..." -ForegroundColor Yellow
    
    # Enable failure auditing for credential validation
    $result = & auditpol /set /subcategory:"Credential Validation" /failure:enable 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Credential validation failure auditing successfully enabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AU-000005 requirement satisfied" -ForegroundColor Green
        
        # Display current audit settings
        Write-Host "`nCurrent audit settings for Credential Validation:" -ForegroundColor Cyan
        auditpol /get /subcategory:"Credential Validation"
    } else {
        Write-Host "✗ Failed to enable credential validation failure auditing" -ForegroundColor Red
        Write-Host "Error: $result" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring audit policy: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: Failed login attempts will be logged in Security event log." -ForegroundColor Yellow