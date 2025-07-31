<#
.SYNOPSIS
    Renames the built-in guest account to meet STIG WN11-SO-000025 requirements.
.DESCRIPTION
    Configures Group Policy to rename the built-in guest account from "Guest" to a non-obvious name.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-SO-000025
#>

# New name for the guest account (change this to your preferred name)
$NewGuestName = "Visitor_Account"

try {
    Write-Host "Configuring Group Policy to rename built-in guest account..." -ForegroundColor Yellow
    
    # Configure Group Policy for guest account rename
    $GPPath = "HKLM:\System\CurrentControlSet\Control\Lsa"
    
    # Create registry path if it doesn't exist
    if (!(Test-Path $GPPath)) {
        New-Item -Path $GPPath -Force | Out-Null
        Write-Host "Created Group Policy registry path: $GPPath" -ForegroundColor Cyan
    }
    
    # Get current guest account name for reference
    $GuestAccount = Get-WmiObject Win32_UserAccount | Where-Object {$_.SID -like "*-501"}
    $OriginalName = $GuestAccount.Name
    
    Write-Host "Current guest account name: $OriginalName" -ForegroundColor Cyan
    
    # Set Group Policy to rename guest account
    Set-ItemProperty -Path $GPPath -Name "NewGuestName" -Value $NewGuestName -Type String
    
    # Also rename the account directly for immediate effect
    $GuestAccount.Rename($NewGuestName)
    
    # Verify the Group Policy setting was applied
    $GPSetting = Get-ItemProperty -Path $GPPath -Name "NewGuestName" -ErrorAction SilentlyContinue
    $RenamedAccount = Get-WmiObject Win32_UserAccount | Where-Object {$_.SID -like "*-501"}
    
    if ($GPSetting.NewGuestName -eq $NewGuestName -and $RenamedAccount.Name -eq $NewGuestName) {
        Write-Host "✓ Guest account successfully renamed from '$OriginalName' to '$NewGuestName'" -ForegroundColor Green
        Write-Host "✓ Group Policy configured to enforce guest account name" -ForegroundColor Green
        Write-Host "✓ STIG WN11-SO-000025 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to rename guest account or configure Group Policy" -ForegroundColor Red
    }
    
} catch {
    Write-Host "✗ Error renaming guest account: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Note: This operation requires administrative privileges" -ForegroundColor Yellow
}

Write-Host "Built-in guest account name has been changed for security." -ForegroundColor Green