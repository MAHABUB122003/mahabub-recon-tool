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

### **Install Dependencies**

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
## 🎮 Usage

### Basic Commands

```bash
# Run recon on a domain
mahabub example.com

# Global usage (if installed)
mahabub google.com

# Show help
mahabub -h
Examples
bash
# Single domain
mahabub tesla.com
```
### **Multiple domains (create a script)**
```
for domain in $(cat domains.txt); do
    mahabub $domain
done
```
### 📂 **Output Structure**
```text
recon_20240101_120000/
├── 📁 subdomains/
│   ├── all_subdomains.txt      # All discovered subdomains
│   ├── subfinder.txt            # Subfinder results
│   ├── assetfinder.txt          # Assetfinder results
│   └── amass.txt                # Amass results
│
├── 📁 alive/
│   ├── alive_domains.txt        # Live hosts with status codes
│   ├── httpx_all.txt            # HTTPx detailed output
│   ├── cdn_detected.txt         # CDN detection
│   └── waf_detected.txt         # WAF detection
│
├── 📁 urls/
│   ├── all_urls.txt             # All extracted URLs
│   ├── param_urls.txt           # URLs with parameters
│   └── parameters.txt           # Unique parameters
│
├── 📁 vulnerabilities/
│   ├── dalfox_xss.txt           # XSS findings
│   ├── nuclei_all.txt           # Nuclei scan results
│   ├── critical_findings.txt    # Critical vulnerabilities
│   ├── sqli_params.txt          # SQLi potential params
│   ├── lfi_params.txt           # LFI potential params
│   └── sensitive_endpoints.txt  # Admin/login pages
│
├── 📁 screenshots/              # Website screenshots
├── 📁 ports/                    # Port scan results
│
├── 📄 FINAL_REPORT.txt          # Comprehensive text report
└── 🌐 report.html               # Interactive HTML report
```
### 📊 **Sample Output**
```text
┌─────────────────────────────────────────────────────────────┐
│                      MAHABUB RECON TOOL                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Usage: ./mahabub.sh <domain>                               │
│  Usage:  mahabub <domain>                                   │
│                                                             │
│  Examples:                                                  │
│   ./mahabub.sh example.com                                  │
│     mahabub google.com                                      │
│     mahabub github.com                                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘

[✓] Subdomains Found:    1,247
[✓] Alive Hosts:         342
[✓] Total URLs:          45,891
[✓] Parameter URLs:      12,456
[✓] Critical Issues:     3
[✓] High Issues:         12
🔥 Advanced Features
Performance Optimizations
Multi-threading: 200+ concurrent threads

Smart Rate Limiting: Avoids IP bans

Resume Capability: Can resume interrupted scans

Memory Efficient: Streams large files

Smart Filtering
Automatically removes duplicate URLs

Filters static files (css, js, images)

Validates domain scope

Removes false positives
```
🎯 Use Cases
Use Case	Description
Bug Bounty	Find subdomains, endpoints, and vulnerabilities
Pentesting	Comprehensive reconnaissance for authorized tests
CTF	Fast enumeration for capture the flag competitions
Security Research	Discover attack surface of organizations
⚙️ Configuration
Custom Threads
bash
# Edit the script to change threads
THREADS=500  # Increase for faster scans
TIMEOUT=3    # Decrease for faster timeouts
API Keys (Optional)
bash
### **Add for better results**
```
export KNOXSS_API_KEY="your_key"
export SECURITYTRAILS_API_KEY="your_key"
export URLSCAN_API_KEY="your_key"
```
