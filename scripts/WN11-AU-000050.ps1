<#
.SYNOPSIS
    Enables process creation auditing to meet STIG WN11-AU-000050 requirements.
.DESCRIPTION
    Configures system to log when programs and processes are started.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-AU-000050
#>

try {
    Write-Host "Enabling process creation auditing..." -ForegroundColor Yellow
    
    # Enable success auditing for process creation
    $result = & auditpol /set /subcategory:"Process Creation" /success:enable 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Process creation auditing successfully enabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AU-000050 requirement satisfied" -ForegroundColor Green
        
        # Enable command line in process creation events
        Write-Host "Enabling command line logging in process creation events..." -ForegroundColor Yellow
        
        $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit"
        if (!(Test-Path $regPath)) {
            New-Item -Path $regPath -Force | Out-Null
        }
        
        Set-ItemProperty -Path $regPath -Name "ProcessCreationIncludeCmdLine_Enabled" -Value 1 -Type DWord
        
        Write-Host "✓ Command line logging enabled for process creation" -ForegroundColor Green
        
        # Display current audit settings
        Write-Host "`nCurrent audit settings for Process Creation:" -ForegroundColor Cyan
        auditpol /get /subcategory:"Process Creation"
    } else {
        Write-Host "✗ Failed to enable process creation auditing" -ForegroundColor Red
        Write-Host "Error: $result" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring audit policy: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: All process launches will be logged with command line details." -ForegroundColor Yellow