# 🔥 MAHABUB RECON TOOL - Ultimate Security Suite

[![Version](https://img.shields.io/badge/version-3.0.1-red.svg)](https://github.com/MAHABUB122003/mahabub-recon-tool)
[![Bash](https://img.shields.io/badge/shell-bash-green.svg)](https://www.gnu.org/software/bash/)
[![Kali](https://img.shields.io/badge/OS-Kali-blue.svg)](https://www.kali.org/)
[![License](https://img.shields.io/badge/license-MIT-yellow.svg)](LICENSE)
[![Tools](https://img.shields.io/badge/tools-25+-orange.svg)]()

<p align="center">
  <img src="https://raw.githubusercontent.com/MAHABUB122003/mahabub-recon-tool/main/banner.png" alt="MAHABUB Recon Tool Banner" width="800">
</p>

## 🎯 **Overview**

**MAHABUB Recon Tool** is a powerful, automated reconnaissance framework designed for **bug bounty hunters** and **penetration testers**. It integrates 25+ security tools to perform comprehensive subdomain enumeration, URL extraction, vulnerability scanning, and reporting.

## 🚀 **Features**

| Category | Features |
|----------|----------|
| **🌐 Subdomain Enumeration** | 15+ tools including Subfinder, Assetfinder, Amass, Chaos |
| **🔍 URL Discovery** | Waybackurls, Gau, Katana, Hakrawler |
| **🛡️ Vulnerability Scanning** | XSS, SQLi, LFI, SSRF, IDOR detection |
| **📸 Visual Recon** | Automated screenshot capture with Gowitness |
| **🔌 Port Scanning** | Naabu integration for service discovery |
| **⚙️ Tech Detection** | Whatweb + HTTPx technology fingerprinting |
| **📊 Professional Reports** | HTML & Text reports with statistics |
| **⚡ High Performance** | 200+ threads, parallel processing |

## 📦 **Integrated Tools**

<details>
<summary><b>Click to see all 25+ tools</b></summary>

| Category | Tools |
|----------|-------|
| **Subdomain** | Subfinder, Assetfinder, Amass, Chaos, DNSEnum, Sublist3r, Knockpy, Findomain, GitHub-Subdomains |
| **Probing** | HTTPx, Httprobe, DNSx, CDNCheck |
| **URL Extraction** | Gau, Waybackurls, Katana, Hakrawler, Archive.org |
| **Vulnerability** | Nuclei, Dalfox, SQLMap, GF Patterns |
| **Infrastructure** | Naabu, Whatweb, Gowitness, TLSx |
| **Takeover** | Subzy, Subjack |
| **Utilities** | Unfurl, Qsreplace, Jq, Anew |

</details>

## 🛠️ **Installation**

### **One-Line Installation**
```bash
git clone https://github.com/MAHABUB122003/mahabub-recon-tool.git
cd mahabub-recon-tool
chmod +x mahabub
sudo cp mahabub /usr/local/bin/
```

###Install Dependencies

```bash
# Go tools
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/tomnomnom/assetfinder@latest
go install -v github.com/lc/gau/v2/cmd/gau@latest

# Python tools
pip install sublist3r knockpy

# Update nuclei templates
nuclei -update-templates
```
