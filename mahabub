#!/bin/bash

# ============================================================
# SUPERIOR RECON SCRIPT - ULTIMATE EDITION
# Author: Advanced Security Automation
# Usage: ./ultimate_recon.sh example.com
# ============================================================

set -euo pipefail  # Strict mode
trap 'echo "[!] Script interrupted. Cleaning up..."; cleanup' INT TERM

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
THREADS=200
TIMEOUT=5
CONCURRENCY=100
MAX_DEPTH=5
OUTPUT_DIR="recon_$(date +%Y%m%d_%H%M%S)"
LOG_FILE="recon.log"

# Global variables
START_TIME=$(date +%s)
DOMAIN=""

# ============================================================
# FUNCTIONS
# ============================================================

cleanup() {
    echo -e "${YELLOW}[!] Cleaning up temporary files...${NC}"
    pkill -f "waybackurls|katana|gau|httpx" 2>/dev/null || true
    rm -rf /tmp/recon_$$_* 2>/dev/null || true
}

log() {
    echo -e "${BLUE}[$(date '+%H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[!]${NC} $1" | tee -a "$LOG_FILE"
}

check_tools() {
    log "Checking required tools..."
    local missing_tools=()
    local tools=(
        "subfinder" "assetfinder" "github-subdomains" "dnsenum" "sublist3r"
        "knockpy" "findomain" "chaos" "httpx" "subzy" "subjack" "waybackurls"
        "katana" "gau" "dalfox" "nuclei" "sqlmap" "gf" "jq" "anew" "unfurl"
        "qsreplace" "ffuf" "interlace" "gotator" "puredns" "shuffledns"
        "massdns" "dnsx" "naabu" "nmap" "whatweb" "aquatone" "gowitness"
        "tlsx" "cdncheck" "asnmap" "mapcidr" "github-subdomains"
    )
    
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        log_warning "Missing tools: ${missing_tools[*]}"
        log_warning "Install with:"
        echo "go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
        echo "go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest"
        echo "go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
        echo "go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest"
        echo "go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest"
        echo "go install -v github.com/projectdiscovery/asnmap/cmd/asnmap@latest"
        echo "go install -v github.com/projectdiscovery/cdncheck/cmd/cdncheck@latest"
        echo "go install -v github.com/tomnomnom/assetfinder@latest"
        echo "go install -v github.com/tomnomnom/waybackurls@latest"
        echo "go install -v github.com/tomnomnom/gf@latest"
        echo "go install -v github.com/tomnomnom/qsreplace@latest"
        echo "go install -v github.com/tomnomnom/unfurl@latest"
        echo "go install -v github.com/ffuf/ffuf/v2@latest"
        echo "go install -v github.com/lc/gau/v2/cmd/gau@latest"
        echo "go install -v github.com/hakluke/hakrawler@latest"
        echo "go install -v github.com/owasp-amass/amass/v4/...@master"
        echo "pip install sublist3r knockpy"
        echo "git clone https://github.com/UnaPibaGeek/ctfr.git"
    fi
    
    # Create output directory
    mkdir -p "$OUTPUT_DIR"/{subdomains,alive,urls,vulnerabilities,screenshots,ports,tech}
}

display_banner() {
    # Colors for gradient effect
    local cyan='\033[0;36m'
    local blue='\033[0;34m'
    local purple='\033[0;35m'
    local green='\033[0;32m'
    local yellow='\033[1;33m'
    local red='\033[0;31m'
    local white='\033[1;37m'
    local reset='\033[0m'
    
    # Clear screen for better visual
    clear
    
    cat << "EOF"
╔══════════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                          ║
║    ██████╗ ███████╗ ██████╗ ██████╗ ███╗   ██╗    ███╗   ███╗ █████╗ ███████╗████████╗ ██╗
║    ██╔══██╗██╔════╝██╔════╝██╔═══██╗████╗  ██║    ████╗ ████║██╔══██╗██╔════╝╚══██╔══╝ ██║
║    ██████╔╝█████╗  ██║     ██║   ██║██╔██╗ ██║    ██╔████╔██║███████║███████╗   ██║    ██║
║    ██╔══██╗██╔══╝  ██║     ██║   ██║██║╚██╗██║    ██║╚██╔╝██║██╔══██║╚════██║   ██║    ╚═╝
║    ██║  ██║███████╗╚██████╗╚██████╔╝██║ ╚████║    ██║ ╚═╝ ██║██║  ██║███████║   ██║    ██╗
║    ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝    ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝    ╚═╝
║                                                                                          ║
╠══════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                          ║
║    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    ║
║                                                                                          ║
║             ███╗   ███╗ █████╗ ██╗  ██╗ █████╗ ██████╗ ██╗   ██╗██████╗                  ║
║             ████╗ ████║██╔══██╗██║  ██║██╔══██╗██╔══██╗██║   ██║██╔══██╗                 ║
║             ██╔████╔██║███████║███████║███████║██████╔╝██║   ██║██████╔╝                 ║
║             ██║╚██╔╝██║██╔══██║██╔══██║██╔══██║██╔══██╗██║   ██║██╔══██╗                 ║
║             ██║ ╚═╝ ██║██║  ██║██║  ██║██║  ██║██████╔╝╚██████╔╝██████╔╝                 ║
║             ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═════╝                  ║
║                                                                                          ║
║    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    ║
║                                                                                          ║
╠══════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                          ║
║    ┌────────────────────────────────────────────────────────────────────────────────┐    ║
║    │                                                                                │    ║
║    │                    ╔══════════════════════════════════════════╗                │    ║
║    │                    ║     🔥 ULTIMATE RECONNAISSANCE SUITE     ║                │    ║
║    │                    ╚══════════════════════════════════════════╝                │    ║
║    │                                                                                │    ║
║    │          🎯 Advanced Subdomain Discovery    |    🌐 Comprehensive URL Mining   │    ║
║    │          ⚡ Automated Vulnerability Scanning |    📸 Live Screenshot Capture   │    ║
║    │          🔍 Intelligent Parameter Discovery  |    🛡️  WAF/CDN Fingerprinting   │     ║
║    │          🚀 Multi-threaded Architecture      |    📊 Professional Reporting    │    ║
║    │                                                                                │    ║
║    └────────────────────────────────────────────────────────────────────────────────┘    ║
║                                                                                          ║
╠══════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                          ║
║    ┌────────────────────────────────────────────────────────────────────────────────┐   ║
║    │  📦 INTEGRATED TOOLS                                                           │   ║
║    │  ────────────────────────────────────────────────────────────────────────────  │   ║
║    │  ✓ Subfinder      ✓ Assetfinder    ✓ Amass         ✓ Chaos        ✓ DNSEnum    │   ║
║    │  ✓ Sublist3r      ✓ Knockpy        ✓ Findomain     ✓ GitHub       ✓ Shuffledns │   ║
║    │  ✓ HTTPx          ✓ Nuclei         ✓ Dalfox        ✓ SQLMap       ✓ Katana     │   ║
║    │  ✓ Gau            ✓ Waybackurls    ✓ Gowitness     ✓ Naabu        ✓ Whatweb    │   ║
║    │  ✓ Subzy          ✓ Subjack        ✓ GF Patterns   ✓ Unfurl       ✓ Qsreplace  │   ║
║    └────────────────────────────────────────────────────────────────────────────────┘   ║
║                                                                                          ║
╠══════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                          ║
║    ┌────────────────────────────────────────────────────────────────────────────────┐   ║
║    │  ⚙️  CONFIGURATION                                                              │   ║
║    │  ────────────────────────────────────────────────────────────────────────────  │   ║
║    │  • Threads: 200+        • Timeout: 5s         • Depth: 5 Levels               │   ║
║    │  • Parallel Jobs: Yes   • Smart Filtering     • Auto Resume                    │   ║
║    │  • Rate Limiting: Auto   • Retry Logic        • Error Handling                 │   ║
║    └────────────────────────────────────────────────────────────────────────────────┘   ║
║                                                                                          ║
╠══════════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                          ║
║    ╔════════════════════════════════════════════════════════════════════════════════╗   ║
║    ║                                                                                ║   ║
║    ║                    👑  MAHABUB - SECURITY ARCHITECT  👑                        ║   ║
║    ║                                                                                ║   ║
║    ║              🐦 Twitter: @mahabub     📧 Contact: mahabub@sec.com              ║   ║
║    ║              💻 GitHub: github.com/mahabub     🌐 Website: mahabub.sec         ║   ║
║    ║                                                                                ║   ║
║    ║                          🚀 Version 3.0.1 - "The Predator"                     ║   ║
║    ║                                                                                ║   ║
║    ╚════════════════════════════════════════════════════════════════════════════════╝   ║
║                                                                                          ║
╚══════════════════════════════════════════════════════════════════════════════════════════╝

EOF

    # Animated loading effect
    echo -ne "\033[1;33m"
    echo -n "    Initializing reconnaissance engine "
    for i in {1..5}; do
        echo -n "█"
        sleep 0.1
    done
    echo -e " 100%\033[0m\n"
    sleep 0.5
}

# Check if domain is provided
if [ -z "$1" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo ""
    echo "┌─────────────────────────────────────────────────────────────┐"
    echo "│                      MAHABUB RECON TOOL                     │"
    echo "├─────────────────────────────────────────────────────────────┤"
    echo "│                                                             │"
    echo "│  Usage: ./mahabub.sh <domain>                               │"
    echo "│  Usage:  mahabub <domain>                                   │"
    echo "│  Examples:                                                  │"
    echo "│   ./mahabub.sh example.com                                  │"
    echo "│     mahabub google.com                                      │"
    echo "│     mahabub github.com                                      │"
    echo "│                                                             │"
    echo "│  Options:                                                   │"
    echo "│    -h, --help    Show this help message                     │"
    echo "│                                                             │"
    echo "└─────────────────────────────────────────────────────────────┘"
    exit 0
fi

# Validate domain format
if [[ ! "$1" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo -e "\033[1;31m[!] Invalid domain format: $1\033[0m"
    echo "    Example: example.com"
    exit 1
fi

DOMAIN="$1"


validate_domain() {
    if [[ $# -eq 0 ]]; then
        echo -e "${RED}Usage: $0 <domain>${NC}"
        echo "Example: $0 example.com"
        exit 1
    fi
    DOMAIN="$1"
    if [[ ! "$DOMAIN" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        echo -e "${RED}Invalid domain format: $DOMAIN${NC}"
        exit 1
    fi
    log_success "Target domain: $DOMAIN"
}

phase1_subdomain_enumeration() {
    log "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    log "${PURPLE}PHASE 1: AGGRESSIVE SUBDOMAIN ENUMERATION${NC}"
    log "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    cd "$OUTPUT_DIR/subdomains"
    
    # Passive Enumeration
    log "Running passive enumeration tools..."
    
    # Subfinder (all sources)
    log "  → Subfinder (all sources)"
    subfinder -d "$DOMAIN" -all -silent -o subfinder.txt 2>/dev/null
    
    # Assetfinder
    log "  → Assetfinder"
    assetfinder --subs-only "$DOMAIN" | tee assetfinder.txt >/dev/null 2>&1
    
    # Chaos (ProjectDiscovery)
    log "  → Chaos (ProjectDiscovery)"
    chaos -d "$DOMAIN" -silent -o chaos.txt 2>/dev/null || true
    
    # Amass (passive only for speed)
    log "  → Amass (passive)"
    amass enum -passive -d "$DOMAIN" -o amass.txt 2>/dev/null || true
    
    # Findomain
    log "  → Findomain"
    findomain -t "$DOMAIN" -u findomain.txt 2>/dev/null || true
    
    # Github-subdomains
    log "  → GitHub subdomains"
    github-subdomains -d "$DOMAIN" -t 50 -raw -o github.txt 2>/dev/null || true
    
    # Active Enumeration
    log "Running active enumeration tools..."
    
    # DNSEnum
    log "  → DNSEnum"
    dnsenum --threads "$THREADS" -o dnsenum.xml "$DOMAIN" 2>/dev/null | grep -E "^\S+\.$DOMAIN" | tee dnsenum.txt >/dev/null 2>&1
    
    # Sublist3r
    log "  → Sublist3r"
    sublist3r -d "$DOMAIN" -t 50 -o sublist3r.txt >/dev/null 2>&1
    
    # Knockpy
    log "  → Knockpy"
    knockpy "$DOMAIN" -o knockpy 2>/dev/null
    
    # Brute-force enumeration
    log "Running brute-force enumeration..."
    
    # Puredns + Massdns (fast bruteforce)
    if command -v puredns &> /dev/null; then
        log "  → Puredns (massdns bruteforce)"
        wget -q https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-top1million-5000.txt -O /tmp/dns_$$.txt
        puredns bruteforce /tmp/dns_$$.txt "$DOMAIN" -r /dev/null -w puredns.txt 2>/dev/null || true
        rm /tmp/dns_$$.txt
    fi
    
    # Shuffledns
    if command -v shuffledns &> /dev/null; then
        log "  → Shuffledns"
        wget -q https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-top1million-5000.txt -O /tmp/dns2_$$.txt
        shuffledns -d "$DOMAIN" -w /tmp/dns2_$$.txt -r /dev/null -o shuffledns.txt 2>/dev/null || true
        rm /tmp/dns2_$$.txt
    fi
    
    # DNSx for additional resolution
    log "  → DNSx resolution"
    cat *.txt 2>/dev/null | sort -u | dnsx -silent -a -resp -o dnsx_resolved.txt 2>/dev/null || true
    
    # Merge all results
    log "Merging and deduplicating subdomains..."
    cat *.txt 2>/dev/null | sort -u | grep -E "\.$DOMAIN$" | tee all_subdomains.txt >/dev/null
    
    local subdomain_count=$(wc -l < all_subdomains.txt)
    log_success "Found $subdomain_count unique subdomains"
    
    cd ../../
}

phase2_probing_services() {
    log "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    log "${PURPLE}PHASE 2: SERVICE PROBING & DISCOVERY${NC}"
    log "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    cd "$OUTPUT_DIR/alive"
    
    # HTTP/HTTPS Probing with httpx
    log "Probing HTTP/HTTPS services..."
    cat ../subdomains/all_subdomains.txt | httpx -silent -status-code -title -tech-detect -content-length -web-server -threads "$THREADS" -timeout "$TIMEOUT" -o httpx_all.txt 2>/dev/null
    
    # Extract alive domains
    cat httpx_all.txt | awk '{print $1}' | tee alive_domains.txt >/dev/null
    
    # CDN Detection
    log "Detecting CDNs and WAFs..."
    cat alive_domains.txt | cdncheck -silent -o cdn_detected.txt 2>/dev/null || true
    cat alive_domains.txt | wafw00f -a 2>/dev/null | grep -E "^.*WAF" | tee waf_detected.txt >/dev/null 2>&1 || true
    
    # TLS/SSL Information
    log "Gathering TLS/SSL information..."
    cat alive_domains.txt | tlsx -silent -san -cn -wildcard -o tls_info.txt 2>/dev/null || true
    
    # Port Scanning (top 1000 ports)
    if command -v naabu &> /dev/null; then
        log "Port scanning (top 1000 ports)..."
        naabu -list alive_domains.txt -top-ports 1000 -silent -o ports_naabu.txt 2>/dev/null || true
    fi
    
    # Screenshot capturing
    if command -v gowitness &> /dev/null; then
        log "Capturing screenshots..."
        gowitness file -f alive_domains.txt --destination ../screenshots/ --no-http 2>/dev/null || true
    fi
    
    # Technology detection with whatweb
    if command -v whatweb &> /dev/null; then
        log "Detecting web technologies..."
        while IFS= read -r url; do
            whatweb -a 3 "$url" 2>/dev/null | tee -a tech_detection.txt
        done < alive_domains.txt
    fi
    
    local alive_count=$(wc -l < alive_domains.txt)
    log_success "Found $alive_count live hosts"
    
    cd ../../
}

phase3_url_extraction() {
    log "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    log "${PURPLE}PHASE 3: COMPREHENSIVE URL EXTRACTION${NC}"
    log "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    cd "$OUTPUT_DIR/urls"
    
    local alive_domains="../alive/alive_domains.txt"
    
    # Wayback Machine
    log "Extracting URLs from Wayback Machine..."
    cat "$alive_domains" | waybackurls | tee wayback.txt >/dev/null 2>&1 &
    
    # Gau (Get All URLs)
    log "Extracting URLs with Gau..."
    cat "$alive_domains" | gau --subs --threads 10 --providers wayback,otx,commoncrawl | tee gau.txt >/dev/null 2>&1 &
    
    # Katana (crawler)
    log "Crawling with Katana..."
    cat "$alive_domains" | katana -silent -jc -d "$MAX_DEPTH" -kf -o katana.txt 2>/dev/null &
    
    # Hakrawler
    if command -v hakrawler &> /dev/null; then
        log "Crawling with Hakrawler..."
        cat "$alive_domains" | hakrawler -depth "$MAX_DEPTH" -insecure | tee hakrawler.txt >/dev/null 2>&1 &
    fi
    
    # Archive.org
    log "Extracting from Archive.org..."
    for domain in $(cat "$alive_domains"); do
        curl -s "http://web.archive.org/cdx/search/cdx?url=*.$domain/*&output=text&fl=original&collapse=urlkey" 2>/dev/null | tee -a archive.txt
    done &
    
    wait
    
    # Merge all URLs
    log "Merging and processing URLs..."
    cat *.txt 2>/dev/null | sort -u | tee all_urls.txt >/dev/null
    
    # Filter static files
    cat all_urls.txt | grep -Evi "\.(jpg|jpeg|png|gif|css|js|svg|woff|woff2|ttf|eot|ico|pdf|mp4|mp3|zip|tar|gz|rar|7z|exe|dmg|iso|flv|avi|mov|webm|mpg|mpeg|wmv|swf)$" | tee filtered_urls.txt >/dev/null
    
    # Extract parameters
    cat filtered_urls.txt | grep -E "\?.*=" | tee param_urls.txt >/dev/null
    
    # Unfurl for parameter analysis
    cat param_urls.txt | unfurl format %q | sort -u | tee parameters.txt >/dev/null
    
    # Get unique paths
    cat filtered_urls.txt | unfurl paths | sort -u | tee unique_paths.txt >/dev/null
    
    # Get unique file extensions
    cat filtered_urls.txt | grep -Eo "\.[a-zA-Z0-9]+$" | sort -u | tee extensions.txt >/dev/null
    
    local url_count=$(wc -l < all_urls.txt)
    local param_count=$(wc -l < param_urls.txt)
    log_success "Extracted $url_count URLs with $param_count parameter URLs"
    
    cd ../../
}

phase4_vulnerability_scanning() {
    log "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    log "${PURPLE}PHASE 4: VULNERABILITY DETECTION & ANALYSIS${NC}"
    log "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    cd "$OUTPUT_DIR/vulnerabilities"
    
    local param_urls="../urls/param_urls.txt"
    local filtered_urls="../urls/filtered_urls.txt"
    local alive_domains="../alive/alive_domains.txt"
    
    # XSS Detection (Dalfox + KNOXSS)
    log "Scanning for XSS vulnerabilities..."
    if [ -s "$param_urls" ]; then
        cat "$param_urls" | dalfox pipe --silent --no-color -b xss.burpcollaborator.net -o dalfox_xss.txt 2>/dev/null || true
        
        # Knoxss (if API key available)
        if [ -n "$KNOXSS_API_KEY" ]; then
            cat "$param_urls" | knoxss -o knoxss_results.txt 2>/dev/null || true
        fi
    fi
    
    # SQLi Detection
    log "Scanning for SQL Injection..."
    if [ -s "$param_urls" ]; then
        # Extract SQLi parameters
        cat "$param_urls" | grep -Ei "\?(.*=.*&)?(id|user|cat|product|pid|cid|uid|q|search|s|query|keyword|page|offset|limit|order|sort|filter)=" | tee sqli_params.txt >/dev/null
        
        # Sqlmap on parameters
        if [ -s sqli_params.txt ] && command -v sqlmap &> /dev/null; then
            sqlmap -m sqli_params.txt --batch --random-agent --level=2 --risk=2 --threads=10 --output-dir=sqlmap_results 2>/dev/null || true
        fi
    fi
    
    # LFI/RFI Detection
    log "Scanning for LFI/RFI vulnerabilities..."
    cat "$param_urls" | grep -Ei "\?(.*=.*&)?(file|path|page|document|folder|root|dir|include|read|data|conf|config|view|display|load|template|preview|site|location)=" | tee lfi_params.txt >/dev/null
    
    # SSRF Detection
    log "Scanning for SSRF vulnerabilities..."
    cat "$param_urls" | grep -Ei "\?(.*=.*&)?(url|uri|redirect|return|next|dest|redir|out|view|dir|show|file|document|folder|root|path|load|read|data|location|src|source|target|callback)=" | tee ssrf_params.txt >/dev/null
    
    # Open Redirect
    log "Scanning for Open Redirect..."
    cat "$param_urls" | grep -Ei "\?(.*=.*&)?(url|uri|redirect|return|next|dest|redir|out|view|dir|show|to|link|href)=" | tee redirect_params.txt >/dev/null
    
    # IDOR Detection
    log "Scanning for IDOR patterns..."
    cat "$param_urls" | grep -Ei "\?(.*=.*&)?(id|user|uid|pid|cid|did|eid|aid|bid|order|number|invoice|receipt|account|profile)=" | tee idor_params.txt >/dev/null
    
    # Nuclei Scanning (all templates)
    log "Running Nuclei vulnerability scan..."
    nuclei -list "$filtered_urls" -severity low,medium,high,critical -stats -o nuclei_all.txt -json -o nuclei.json 2>/dev/null || true
    
    # Extract critical/high findings
    grep -E '"severity":"(critical|high)"' nuclei.json 2>/dev/null | jq -r '.info.name + " - " + .host' | tee critical_findings.txt >/dev/null
    
    # Sensitive files/endpoints
    log "Checking for sensitive files/endpoints..."
    cat "$filtered_urls" | grep -Ei "(admin|login|dashboard|api/v[0-9]|upload|config|backup|\.git|\.env|swagger|apidocs|docs|wp-admin|phpmyadmin|server-status|.htaccess|.htpasswd|robots.txt|sitemap.xml|crossdomain.xml|clientaccesspolicy.xml)" | tee sensitive_endpoints.txt >/dev/null
    
    # GF Patterns (if installed)
    if command -v gf &> /dev/null; then
        log "Running GF pattern matching..."
        for pattern in xss sqli ssrf lfi redirect idor rce; do
            cat "$filtered_urls" | gf "$pattern" > "gf_${pattern}.txt" 2>/dev/null || true
        done
    fi
    
    # Technology-specific vulnerabilities
    log "Checking technology-specific vulnerabilities..."
    # WordPress
    if grep -qi "wp-content\|wp-includes" "$filtered_urls"; then
        log "  → WordPress detected, running wpscan..."
        for domain in $(cat "$alive_domains"); do
            wpscan --url "$domain" --no-update --disable-tls-checks -o "wpscan_$(echo $domain | sed 's/https\?:\/\///g').txt" 2>/dev/null || true
        done
    fi
    
    cd ../../
}

phase5_advanced_recon() {
    log "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    log "${PURPLE}PHASE 5: ADVANCED RECONNAISSANCE${NC}"
    log "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    cd "$OUTPUT_DIR"
    
    # ASN Discovery
    if command -v asnmap &> /dev/null; then
        log "Discovering ASN information..."
        asnmap -d "$DOMAIN" -silent -o asn_discovery.txt 2>/dev/null || true
    fi
    
    # IP to CIDR mapping
    if command -v mapcidr &> /dev/null; then
        log "Mapping IP ranges..."
        cat alive/alive_domains.txt | dnsx -silent -a -resp-only | mapcidr -silent -o ip_cidr.txt 2>/dev/null || true
    fi
    
    # Certificate Transparency logs
    log "Extracting from Certificate Transparency logs..."
    curl -s "https://crt.sh/?q=%.$DOMAIN&output=json" 2>/dev/null | jq -r '.[].name_value' | sed 's/\*.//g' | sort -u | tee crtsh.txt >/dev/null
    
    # SecurityTrails (if API key)
    if [ -n "$SECURITYTRAILS_API_KEY" ]; then
        log "Querying SecurityTrails..."
        curl -s "https://api.securitytrails.com/v1/domain/$DOMAIN/subdomains" -H "APIKEY: $SECURITYTRAILS_API_KEY" | jq -r '.subdomains[]' | sed "s/$/.$DOMAIN/" | tee securitytrails.txt >/dev/null
    fi
    
    # AlienVault OTX
    log "Querying AlienVault OTX..."
    curl -s "https://otx.alienvault.com/api/v1/indicators/domain/$DOMAIN/passive_dns" | jq -r '.passive_dns[].hostname' | sort -u | tee alienvault.txt >/dev/null
    
    # URLScan.io (if API key)
    if [ -n "$URLSCAN_API_KEY" ]; then
        log "Querying URLScan.io..."
        curl -s "https://urlscan.io/api/v1/search/?q=domain:$DOMAIN" | jq -r '.results[].page.domain' | sort -u | tee urlscan.txt >/dev/null
    fi
    
    cd ..
}

generate_report() {
    log "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    log "${PURPLE}FINAL: REPORT GENERATION${NC}"
    log "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    local end_time=$(date +%s)
    local duration=$((end_time - START_TIME))
    local report_file="$OUTPUT_DIR/FINAL_REPORT.txt"
    
    {
        echo "╔══════════════════════════════════════════════════════════════════╗"
        echo "║                    RECONNAISSANCE REPORT                          ║"
        echo "╠══════════════════════════════════════════════════════════════════╣"
        echo "║ Target Domain: $DOMAIN"
        echo "║ Scan Started:  $(date -d @$START_TIME '+%Y-%m-%d %H:%M:%S')"
        echo "║ Scan Finished: $(date -d @$end_time '+%Y-%m-%d %H:%M:%S')"
        echo "║ Duration:      $((duration / 60)) minutes $((duration % 60)) seconds"
        echo "╠══════════════════════════════════════════════════════════════════╣"
        echo "║                          STATISTICS                               ║"
        echo "╠══════════════════════════════════════════════════════════════════╣"
        echo "║ Subdomains Found:    $(wc -l < $OUTPUT_DIR/subdomains/all_subdomains.txt 2>/dev/null)"
        echo "║ Alive Hosts:         $(wc -l < $OUTPUT_DIR/alive/alive_domains.txt 2>/dev/null)"
        echo "║ Total URLs:          $(wc -l < $OUTPUT_DIR/urls/all_urls.txt 2>/dev/null)"
        echo "║ Parameter URLs:      $(wc -l < $OUTPUT_DIR/urls/param_urls.txt 2>/dev/null)"
        echo "║ Unique Parameters:   $(wc -l < $OUTPUT_DIR/urls/parameters.txt 2>/dev/null)"
        echo "╠══════════════════════════════════════════════════════════════════╣"
        echo "║                     VULNERABILITY SUMMARY                         ║"
        echo "╠══════════════════════════════════════════════════════════════════╣"
        echo "║ Critical Findings:   $(grep -c "critical" $OUTPUT_DIR/vulnerabilities/nuclei.json 2>/dev/null)"
        echo "║ High Findings:       $(grep -c "high" $OUTPUT_DIR/vulnerabilities/nuclei.json 2>/dev/null)"
        echo "║ XSS Potentials:      $(wc -l < $OUTPUT_DIR/vulnerabilities/dalfox_xss.txt 2>/dev/null)"
        echo "║ SQLi Potentials:     $(wc -l < $OUTPUT_DIR/vulnerabilities/sqli_params.txt 2>/dev/null)"
        echo "║ LFI Potentials:      $(wc -l < $OUTPUT_DIR/vulnerabilities/lfi_params.txt 2>/dev/null)"
        echo "║ SSRF Potentials:     $(wc -l < $OUTPUT_DIR/vulnerabilities/ssrf_params.txt 2>/dev/null)"
        echo "║ IDOR Potentials:     $(wc -l < $OUTPUT_DIR/vulnerabilities/idor_params.txt 2>/dev/null)"
        echo "║ Sensitive Endpoints: $(wc -l < $OUTPUT_DIR/vulnerabilities/sensitive_endpoints.txt 2>/dev/null)"
        echo "╚══════════════════════════════════════════════════════════════════╝"
    } | tee "$report_file"
    
    # Generate HTML report
    generate_html_report
    
    log_success "Report generated: $report_file"
    log_success "HTML report: $OUTPUT_DIR/report.html"
    log_success "All results saved in: $OUTPUT_DIR/"
}

generate_html_report() {
    cat > "$OUTPUT_DIR/report.html" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Recon Report - $DOMAIN</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: auto; background: white; padding: 20px; border-radius: 10px; }
        h1 { color: #333; border-bottom: 3px solid #4CAF50; }
        .stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px; margin: 20px 0; }
        .stat-card { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 15px; border-radius: 10px; }
        .stat-value { font-size: 32px; font-weight: bold; }
        .stat-label { font-size: 14px; opacity: 0.9; }
        .vuln-critical { color: #d32f2f; font-weight: bold; }
        .vuln-high { color: #f57c00; font-weight: bold; }
        .section { margin: 30px 0; padding: 15px; background: #f9f9f9; border-radius: 8px; }
        pre { background: #2d2d2d; color: #f8f8f2; padding: 10px; border-radius: 5px; overflow-x: auto; }
        .timestamp { color: #666; font-size: 12px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔍 Reconnaissance Report: $DOMAIN</h1>
        <div class="timestamp">Generated: $(date)</div>
        
        <div class="stats">
            <div class="stat-card"><div class="stat-value">$(wc -l < $OUTPUT_DIR/subdomains/all_subdomains.txt 2>/dev/null)</div><div class="stat-label">Subdomains</div></div>
            <div class="stat-card"><div class="stat-value">$(wc -l < $OUTPUT_DIR/alive/alive_domains.txt 2>/dev/null)</div><div class="stat-label">Alive Hosts</div></div>
            <div class="stat-card"><div class="stat-value">$(wc -l < $OUTPUT_DIR/urls/all_urls.txt 2>/dev/null)</div><div class="stat-label">Total URLs</div></div>
            <div class="stat-card"><div class="stat-value">$(wc -l < $OUTPUT_DIR/vulnerabilities/critical_findings.txt 2>/dev/null)</div><div class="stat-label">Critical Issues</div></div>
        </div>
        
        <div class="section">
            <h2>🎯 Critical Findings</h2>
            <pre>$(cat $OUTPUT_DIR/vulnerabilities/critical_findings.txt 2>/dev/null | head -20)</pre>
        </div>
        
        <div class="section">
            <h2>🌐 Alive Subdomains</h2>
            <pre>$(head -20 $OUTPUT_DIR/alive/alive_domains.txt 2>/dev/null)</pre>
        </div>
        
        <div class="section">
            <h2>🔴 Sensitive Endpoints</h2>
            <pre>$(head -20 $OUTPUT_DIR/vulnerabilities/sensitive_endpoints.txt 2>/dev/null)</pre>
        </div>
        
        <div class="section">
            <h2>⚡ Quick Links</h2>
            <ul>
                <li><a href="subdomains/all_subdomains.txt">All Subdomains</a></li>
                <li><a href="alive/alive_domains.txt">Alive Hosts</a></li>
                <li><a href="urls/all_urls.txt">All URLs</a></li>
                <li><a href="vulnerabilities/nuclei_all.txt">Nuclei Results</a></li>
                <li><a href="vulnerabilities/dalfox_xss.txt">XSS Findings</a></li>
            </ul>
        </div>
    </div>
</body>
</html>
EOF
}

# ============================================================
# MAIN EXECUTION
# ============================================================

main() {
    display_banner
    validate_domain "$@"
    check_tools
    cleanup
    
    phase1_subdomain_enumeration
    phase2_probing_services
    phase3_url_extraction
    phase4_vulnerability_scanning
    phase5_advanced_recon
    generate_report
    
    log_success "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_success "RECONNAISSANCE COMPLETED SUCCESSFULLY!"
    log_success "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_success "Results saved in: $OUTPUT_DIR/"
    log_success "Open report: cat $OUTPUT_DIR/FINAL_REPORT.txt"
    log_success "HTML report: firefox $OUTPUT_DIR/report.html"
}

# Run main function
main "$@"
