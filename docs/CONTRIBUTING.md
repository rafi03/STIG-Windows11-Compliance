# Contributing to Windows 11 STIG Compliance Automation

Thank you for your interest in contributing to this project! This guide will help you get started with contributing to our Windows 11 STIG compliance automation scripts.

## 🤝 How to Contribute

### Reporting Issues
- **Bug Reports**: Use the GitHub issue template for bugs
- **Feature Requests**: Suggest new STIG remediations or improvements
- **Documentation**: Report unclear or missing documentation

### Code Contributions

#### Prerequisites
- Windows 11 testing environment
- PowerShell 5.1 or later
- Administrative privileges for testing
- Basic understanding of Windows Registry and Group Policy

#### Development Setup
1. Fork the repository
2. Clone your fork locally:
   ```bash
   git clone https://github.com/yourusername/windows11-stig-compliance.git
   ```
3. Create a feature branch:
   ```bash
   git checkout -b feature/new-stig-remediation
   ```

## 📝 Coding Standards

### PowerShell Script Standards

#### File Naming Convention
```
STIG-ID-[STIG-IDENTIFIER].ps1
```
Example: `STIG-ID-WN11-AU-000500.ps1`

#### Script Header Template
```powershell
<#
.SYNOPSIS
    Brief description of what the script does
.DESCRIPTION
    Detailed explanation of the STIG requirement and remediation
.NOTES
    Author          : [Your Name]
    LinkedIn        : [Your LinkedIn URL]
    GitHub          : [Your GitHub Username]
    Date Created    : YYYY-MM-DD
    Last Modified   : YYYY-MM-DD
    Version         : 1.0
    CVEs            : N/A (or list relevant CVEs)
    Plugin IDs      : N/A (or list relevant Nessus/Tenable IDs)
    STIG-ID         : [Official STIG ID]
.TESTED ON
    Date(s) Tested  : YYYY-MM-DD
    Tested By       : [Your Name]
    Systems Tested  : Windows 11 [Edition]
    PowerShell Ver. : [Version]
.USAGE
    Brief usage instructions
    Example syntax:
    PS C:\> .\STIG-ID-[IDENTIFIER].ps1
#>
```

#### Code Structure Requirements

1. **Error Handling**: All scripts must use try-catch blocks
2. **Verification**: Include verification of applied settings
3. **User Feedback**: Provide clear, color-coded output
4. **Comments**: Explain complex operations and registry paths
5. **Variables**: Use descriptive variable names

#### Example Code Structure
```powershell
# Define required values
$RequiredValue = [value]
$RegistryPath = "[path]"

try {
    Write-Host "Starting [STIG ID] remediation..." -ForegroundColor Yellow
    
    # Create registry path if needed
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Apply the security setting
    Set-ItemProperty -Path $RegistryPath -Name "[SettingName]" -Value $RequiredValue -Type DWord
    
    # Verify the setting
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "[SettingName]" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.[SettingName] -eq $RequiredValue) {
        Write-Host "✓ [STIG ID] requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to apply [STIG ID] setting" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error applying [STIG ID]: $($_.Exception.Message)" -ForegroundColor Red
}
```

### Documentation Standards

#### README Updates
When adding new scripts, update the main README.md:

1. **Add to STIG table**: Include STIG ID, category, severity, description
2. **Add detailed section**: Following the established format with:
   - 🎯 The Big Picture
   - 📋 Our Strategy  
   - 🔍 Detailed Code Analysis
   - 🛡️ Security Impact

#### Code Comments
- Explain WHY, not just WHAT
- Include security context
- Explain registry path purposes
- Document any Windows version differences

## 🧪 Testing Requirements

### Before Submitting
1. **Clean Environment Testing**: Test on fresh Windows 11 installation
2. **Verification**: Confirm the STIG requirement is actually remediated
3. **Rollback Testing**: Ensure changes can be reversed if needed
4. **Error Scenarios**: Test with insufficient permissions, missing paths, etc.

### Testing Checklist
- [ ] Script runs without errors on Windows 11
- [ ] Registry changes are applied correctly
- [ ] Verification logic works properly
- [ ] Error handling manages failures gracefully
- [ ] Output is clear and informative
- [ ] No unintended side effects

## 📋 Pull Request Process

### Submission Requirements
1. **Branch**: Create from main branch
2. **Commits**: Use clear, descriptive commit messages
3. **Testing**: Include testing evidence in PR description
4. **Documentation**: Update README.md with new script details

### PR Template
```markdown
## STIG Remediation: [STIG-ID]

### Description
Brief description of the STIG requirement and your solution.

### Changes Made
- [ ] Added new remediation script
- [ ] Updated documentation
- [ ] Added verification checks
- [ ] Included error handling

### Testing
- **Environment**: Windows 11 [Edition]
- **PowerShell Version**: [Version]
- **Testing Date**: [Date]
- **Results**: [Pass/Fail with details]

### STIG Compliance
- **STIG ID**: [ID]
- **Severity**: [CAT I/II/III]
- **Verification Method**: [How you confirmed it works]

### Checklist
- [ ] Code follows project standards
- [ ] Documentation updated
- [ ] Testing completed
- [ ] No breaking changes
```

## 🔒 Security Considerations

### Script Security
- **Principle of Least Privilege**: Only modify what's necessary
- **Verification**: Always verify changes were applied
- **Reversibility**: Document how to undo changes if needed
- **Testing**: Never test on production systems

### Sensitive Information
- **No Hardcoded Secrets**: Never include passwords, keys, or sensitive data
- **Environment Specific**: Avoid hardcoding domain names, server names, etc.
- **User Privacy**: Respect user privacy in logging and output

## 📞 Getting Help

### Resources
- **DISA STIG Documentation**: Official STIG guides
- **PowerShell Documentation**: Microsoft PowerShell docs
- **Project Issues**: GitHub issues for project-specific questions

### Contact
- **GitHub Issues**: For bug reports and feature requests
- **Discussions**: For general questions and community support

## 🏆 Recognition

Contributors will be recognized in:
- **README.md**: Contributors section
- **Individual Scripts**: Author attribution in script headers
- **Release Notes**: Major contributions highlighted

Thank you for helping make Windows systems more secure! 🛡️