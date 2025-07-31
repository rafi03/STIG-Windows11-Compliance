<#
.SYNOPSIS
    Enables PowerShell transcription logging to meet STIG WN11-CC-000327 requirements.
.DESCRIPTION
    Configures PowerShell to create transcription logs of all PowerShell activity.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000327
#>

# Registry path for PowerShell transcription
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription"

# Secure transcript output directory
$TranscriptPath = "C:\PowerShellTranscripts"

try {
    Write-Host "Enabling PowerShell transcription logging..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Create transcript directory if it doesn't exist
    if (!(Test-Path $TranscriptPath)) {
        New-Item -Path $TranscriptPath -ItemType Directory -Force | Out-Null
        Write-Host "Created transcript directory: $TranscriptPath" -ForegroundColor Cyan
        
        # Set secure permissions on transcript directory (Administrators only)
        $Acl = Get-Acl $TranscriptPath
        $Acl.SetAccessRuleProtection($true, $false)  # Remove inheritance
        $AdminRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
        $SystemRule = New-Object System.Security.AccessControl.FileSystemAccessRule("SYSTEM", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
        $Acl.SetAccessRule($AdminRule)
        $Acl.SetAccessRule($SystemRule)
        Set-Acl -Path $TranscriptPath -AclObject $Acl
        Write-Host "Set secure permissions on transcript directory" -ForegroundColor Cyan
    }
    
    # Enable PowerShell transcription
    Set-ItemProperty -Path $RegistryPath -Name "EnableTranscripting" -Value 1 -Type DWord
    
    # Set transcript output directory
    Set-ItemProperty -Path $RegistryPath -Name "OutputDirectory" -Value $TranscriptPath -Type String
    
    # Enable invocation headers in transcripts
    Set-ItemProperty -Path $RegistryPath -Name "EnableInvocationHeader" -Value 1 -Type DWord
    
    # Verify the settings were applied
    $TranscriptSetting = Get-ItemProperty -Path $RegistryPath -Name "EnableTranscripting" -ErrorAction SilentlyContinue
    $DirectorySetting = Get-ItemProperty -Path $RegistryPath -Name "OutputDirectory" -ErrorAction SilentlyContinue
    
    if ($TranscriptSetting.EnableTranscripting -eq 1 -and $DirectorySetting.OutputDirectory -eq $TranscriptPath) {
        Write-Host "✓ PowerShell transcription successfully enabled" -ForegroundColor Green
        Write-Host "✓ Transcript directory: $TranscriptPath" -ForegroundColor Green
        Write-Host "✓ Invocation headers enabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000327 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to enable PowerShell transcription" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring PowerShell transcription: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "PowerShell sessions will now be transcribed to: $TranscriptPath" -ForegroundColor Green