<#
.SYNOPSIS
    Configures account lockout duration to meet STIG WN11-AC-000005 requirements.
.DESCRIPTION
    Sets the account lockout duration to 15 minutes as required by STIG.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-AC-000005
#>

try {
    Write-Host "Configuring account lockout duration..." -ForegroundColor Yellow
    
    # Set lockout duration to 15 minutes
    $result = & net accounts /lockoutduration:15 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Account lockout duration successfully set to 15 minutes" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AC-000005 requirement satisfied" -ForegroundColor Green
        
        # Display current settings
        Write-Host "`nCurrent account policy settings:" -ForegroundColor Cyan
        net accounts | Select-String "Lockout duration"
    } else {
        Write-Host "✗ Failed to set account lockout duration" -ForegroundColor Red
        Write-Host "Error: $result" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring account lockout duration: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: Locked accounts will remain locked for 15 minutes." -ForegroundColor Yellow