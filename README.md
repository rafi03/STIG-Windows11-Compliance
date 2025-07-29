# Windows 11 STIG Compliance Automation

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)](https://github.com/PowerShell/PowerShell)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![STIG](https://img.shields.io/badge/STIG-Windows%2011-red.svg)](https://public.cyber.mil/stigs/)

An automated PowerShell solution for remediating Windows 11 Security Technical Implementation Guide (STIG) compliance findings identified through Tenable vulnerability management scans.

## 🎯 Project Overview

This repository contains PowerShell scripts designed to automatically remediate common STIG compliance failures on Windows 11 systems. Each script targets specific STIG requirements and can be run individually or as part of a comprehensive remediation suite.

### Key Features
- **Automated Remediation**: PowerShell scripts for ~20 common STIG compliance issues
- **Tenable Integration**: Designed to work with Tenable vulnerability scan results
- **Modular Design**: Each STIG requirement has its own dedicated script
- **Compliance Reporting**: Automated reporting and documentation
- **Comprehensive Logging**: Detailed execution and compliance reporting

## 📋 Prerequisites

- Windows 11 (Target system)
- PowerShell 5.1 or later
- Administrative privileges
- Tenable vulnerability management platform (for scanning)

## 🚀 Quick Start

1. **Clone the repository**
   ```powershell
   git clone https://github.com/[USERNAME]/STIG-Windows11-Compliance.git
   cd STIG-Windows11-Compliance
   ```

2. **Review and customize configuration**
   ```powershell
   # Edit configuration files as needed
   notepad config/remediation-config.json
   ```

3. **Run individual remediation scripts**
   ```powershell
   # Execute specific STIG remediation
   .\scripts\remediation\STIG-ID-WN10-AU-000500.ps1
   ```

4. **Run all remediations**
   ```powershell
   # Execute all remediation scripts
   .\scripts\utilities\Run-AllRemediations.ps1
   ```

## 📁 Repository Structure

### `/scripts/remediation/`
Contains individual PowerShell scripts for each STIG requirement:
- Each script follows the naming convention: `STIG-ID-[IDENTIFIER].ps1`
- Scripts include comprehensive documentation and error handling
- Designed for both interactive and automated execution

### `/scripts/utilities/`
Helper scripts for managing the remediation process:
- `Run-AllRemediations.ps1` - Execute all remediation scripts
- `Generate-ComplianceReport.ps1` - Create detailed compliance reports

### `/docs/`
Documentation and reference materials:
- `STIG-MAPPING.md` - Mapping of STIG IDs to remediation scripts
- `INSTALLATION.md` - Detailed installation and setup instructions
- `TROUBLESHOOTING.md` - Common issues and solutions

## 🔧 Supported STIG Requirements

*Note: This section will be updated as scripts are added*

| STIG ID | Description | Script Status |
|---------|-------------|---------------|
| WN10-AU-000500 | Windows Application event log maximum size | ✅ Available |
| [Additional entries will be added as scripts are uploaded] | | |

## 📊 Usage Examples

### Running Individual Scripts
```powershell
# Remediate specific STIG requirement
.\scripts\remediation\STIG-ID-WN10-AU-000500.ps1

# Run with verbose output
.\scripts\remediation\STIG-ID-WN10-AU-000500.ps1 -Verbose
```

### Batch Remediation
```powershell
# Run all available remediations
.\scripts\utilities\Run-AllRemediations.ps1

# Run with custom configuration
.\scripts\utilities\Run-AllRemediations.ps1 -ConfigPath ".\config\custom-config.json"
```

### Validation and Reporting
```powershell
# Generate compliance report
.\scripts\utilities\Generate-ComplianceReport.ps1 -OutputPath ".\reports\compliance-$(Get-Date -Format 'yyyyMMdd').html"
```

## 🔍 Integration with Tenable

This project is designed to work seamlessly with Tenable vulnerability management:

1. **Scan Phase**: Use Tenable to scan Windows 11 systems for STIG compliance
2. **Analysis Phase**: Review audit logs and identify failed STIG requirements
3. **Remediation Phase**: Use corresponding PowerShell scripts to address findings
4. **Validation Phase**: Re-scan with Tenable to verify successful remediation

## ⚠️ Important Considerations

- **Test First**: Always test scripts in a non-production environment
- **Backup Configuration**: Create system restore points before running scripts
- **Review Changes**: Understand what each script modifies before execution
- **Administrative Rights**: Scripts require elevated PowerShell sessions
- **System Impact**: Some remediations may require system restart

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-stig-remediation`)
3. Follow the established script template and documentation standards
4. Submit a pull request with detailed description

### Script Template
All remediation scripts should follow the established template format including:
- Comprehensive synopsis and documentation
- Author attribution and version information
- STIG ID and requirement mapping
- Proper error handling and logging
- Usage examples and testing notes

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Josh Madakor** - Original script template and methodology
- **DISA STIG Team** - Security Technical Implementation Guides
- **Tenable** - Vulnerability management platform integration
- **Community Contributors** - Ongoing improvements and additional STIG remediations

## 📞 Support

For questions, issues, or suggestions:
- Open an issue in this repository
- Review the [troubleshooting documentation](docs/TROUBLESHOOTING.md)
- Check existing discussions and issues

## 🔄 Changelog

See [CHANGELOG.md](docs/CHANGELOG.md) for detailed version history and updates.

---

**Disclaimer**: This project is provided as-is for educational and professional use. Always test in non-production environments and ensure compliance with your organization's security policies before implementing in production systems.