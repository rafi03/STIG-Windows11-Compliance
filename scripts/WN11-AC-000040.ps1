<#
.SYNOPSIS
    Enables password complexity to meet STIG WN11-AC-000040 requirements.
.DESCRIPTION
    Configures system to require complex passwords with multiple character types.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-AC-000040
#>

try {
    Write-Host "Enabling password complexity requirements..." -ForegroundColor Yellow
    
    # Create temporary security policy file
    $tempFile = "$env:TEMP\secpol.cfg"
    
    # Export current security policy
    $exportResult = & secedit /export /cfg $tempFile /quiet 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        # Read and modify the policy file
        $content = Get-Content $tempFile
        $content = $content -replace "PasswordComplexity = 0", "PasswordComplexity = 1"
        $content | Set-Content $tempFile
        
        # Apply the modified policy
        $importResult = & secedit /configure /db secedit.sdb /cfg $tempFile /areas SECURITYPOLICY /quiet 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Password complexity successfully enabled" -ForegroundColor Green
            Write-Host "✓ STIG WN11-AC-000040 requirement satisfied" -ForegroundColor Green
            
            Write-Host "`nPassword complexity requirements:" -ForegroundColor Cyan
            Write-Host "• Must contain characters from 3 of 4 categories:" -ForegroundColor Gray
            Write-Host "  - Uppercase letters (A-Z)" -ForegroundColor Gray
            Write-Host "  - Lowercase letters (a-z)" -ForegroundColor Gray
            Write-Host "  - Numbers (0-9)" -ForegroundColor Gray
            Write-Host "  - Special characters (!@#$%^&*)" -ForegroundColor Gray
        } else {
            Write-Host "✗ Failed to apply password complexity policy" -ForegroundColor Red
        }
    } else {
        Write-Host "✗ Failed to export security policy" -ForegroundColor Red
    }
    
    # Clean up
    if (Test-Path $tempFile) {
        Remove-Item $tempFile -Force
    }
} catch {
    Write-Host "✗ Error configuring password complexity: $($_.Exception.Message)" -ForegroundColor Red
}
