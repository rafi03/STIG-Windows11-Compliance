<#
.SYNOPSIS
    Configures password history to meet STIG WN11-AC-000020 requirements.
.DESCRIPTION
    Sets the system to remember 24 passwords as required by STIG.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-AC-000020
#>

try {
    Write-Host "Configuring password history..." -ForegroundColor Yellow
    
    # Set password history to 24 passwords
    $result = & net accounts /uniquepw:24 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Password history successfully set to 24 passwords" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AC-000020 requirement satisfied" -ForegroundColor Green
        
        # Display current settings
        Write-Host "`nCurrent password policy settings:" -ForegroundColor Cyan
        net accounts | Select-String "password history"
    } else {
        Write-Host "✗ Failed to set password history" -ForegroundColor Red
        Write-Host "Error: $result" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring password history: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: Users cannot reuse their last 24 passwords." -ForegroundColor Yellow