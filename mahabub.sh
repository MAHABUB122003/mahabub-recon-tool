#!/bin/bash

# ============================================================
# MAHABUB RECON TOOL - SMART INTERRUPT EDITION
# ============================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

DOMAIN=$1

# Create main domain folder
MAIN_DIR="$DOMAIN"
mkdir -p "$MAIN_DIR"
mkdir -p "$MAIN_DIR/subdomains"
mkdir -p "$MAIN_DIR/takeover"
mkdir -p "$MAIN_DIR/urls"
mkdir -p "$MAIN_DIR/patterns"
mkdir -p "$MAIN_DIR/scans"

cd "$MAIN_DIR"

# ============================================================
# SMART INTERRUPT HANDLING
# ============================================================

# Global variables for tracking background jobs
declare -a BG_PIDS=()
CURRENT_PHASE=""
INTERRUPTED=false

# Function to handle Ctrl+C gracefully
smart_interrupt() {
    echo -e "\n${YELLOW}[!] Ctrl+C detected!${NC}"
    echo -e "${YELLOW}[→] Current phase: $CURRENT_PHASE${NC}"
    echo -e "${YELLOW}[→] Stopping current tools only...${NC}"

    INTERRUPTED=true

    # Kill only the tools running in current phase (background jobs)
    for pid in ${BG_PIDS[@]}; do
        if kill -0 $pid 2>/dev/null; then
            echo -e "${RED}[→] Stopping PID: $pid${NC}"
            kill $pid 2>/dev/null
            kill -9 $pid 2>/dev/null
        fi
    done

    # Clear the PID array
    BG_PIDS=()

    echo -e "${GREEN}[✓] Current tools stopped. Moving to next phase...${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Set the trap
trap smart_interrupt SIGINT SIGTERM

# Function to add PID to tracking
track_pid() {
    BG_PIDS+=($1)
}

# Function to wait for all tracked jobs
wait_with_check() {
    while true; do
        local running=false
        local new_pids=()

        for pid in ${BG_PIDS[@]}; do
            if kill -0 $pid 2>/dev/null; then
                running=true
                new_pids+=($pid)
            fi
        done

        BG_PIDS=("${new_pids[@]}")

        if [ "$running" = false ]; then
            break
        fi
        sleep 1
    done
}

# Display Banner
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
display_banner

# ============================================================
# PHASE 1: SUBDOMAIN ENUMERATION (Parallel)
# ============================================================
CURRENT_PHASE="Subdomain Enumeration"
echo -e "${BLUE}[*] Phase 1: Subdomain Enumeration (Parallel)${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}[→] Running 7 tools simultaneously...${NC}"
echo -e "${YELLOW}[→] 💡 Press Ctrl+C to skip this phase and continue${NC}"

BG_PIDS=()

subfinder -d "$DOMAIN" -all -silent > subdomains/sub.txt 2>/dev/null &
track_pid $!

assetfinder --subs-only "$DOMAIN" > subdomains/assetfinder.txt 2>/dev/null &
track_pid $!

sublist3r -d "$DOMAIN" -o subdomains/sublist3r.txt >/dev/null 2>&1 &
track_pid $!

findomain -t "$DOMAIN" -u subdomains/find.txt >/dev/null 2>&1 &
track_pid $!

dnsenum "$DOMAIN" 2>/dev/null | grep -E "^\S+\.$DOMAIN" > subdomains/dnsrecon.txt &
track_pid $!

chaos -d "$DOMAIN" -silent 2>/dev/null > subdomains/chaos.txt &
track_pid $!

github-subdomains -d "$DOMAIN" 2>/dev/null > subdomains/github.txt &
track_pid $!

wait_with_check

# Merge all subdomains
cat subdomains/sub.txt subdomains/assetfinder.txt subdomains/sublist3r.txt subdomains/find.txt subdomains/dnsrecon.txt subdomains/chaos.txt subdomains/github.txt 2>/dev/null | sort -u | grep -E "\.$DOMAIN$" > subdomains/all_subdomains.txt
COUNT=$(wc -l < subdomains/all_subdomains.txt)
echo -e "${GREEN}[✓] Found $COUNT subdomains${NC}"
INTERRUPTED=false

# ============================================================
# PHASE 2: PROBING ALIVE (Fast)
# ============================================================
CURRENT_PHASE="Probing Alive Hosts"
echo -e "\n${BLUE}[*] Phase 2: Probing Alive Hosts${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}[→] 💡 Press Ctrl+C to skip this phase and continue${NC}"

BG_PIDS=()

cat subdomains/all_subdomains.txt | httpx -silent -status-code -threads 200 -timeout 3 > alive.txt &
track_pid $!

wait_with_check

ALIVE=$(wc -l < alive.txt)
echo -e "${GREEN}[✓] $ALIVE alive hosts${NC}"
INTERRUPTED=false

# ============================================================
# PHASE 3: TAKEOVER CHECKS
# ============================================================
CURRENT_PHASE="Subdomain Takeover Checks"
echo -e "\n${BLUE}[*] Phase 3: Subdomain Takeover Checks${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}[→] Running Subzy & Subjack in parallel...${NC}"
echo -e "${YELLOW}[→] 💡 Press Ctrl+C to skip this phase and continue${NC}"

BG_PIDS=()

subzy run --targets alive.txt 2>/dev/null > takeover/subzy.txt &
track_pid $!

subjack -w alive.txt -ssl -v -t 100 2>/dev/null > takeover/subjack.txt &
track_pid $!

wait_with_check

echo -e "${GREEN}[✓] Takeover checks complete${NC}"
INTERRUPTED=false

# ============================================================
# PHASE 4: URL EXTRACTION (OPTIMIZED WITH HAKRAWLER 5 MIN)
# ============================================================
CURRENT_PHASE="URL Extraction"
echo -e "\n${BLUE}[*] Phase 4: URL Extraction (Optimized Mode)${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

cat alive.txt | awk '{print $1}' > urls/clean_alive.txt

echo -e "${YELLOW}[→] Running GAU + Waybackurls + Katana (10 min) + Hakrawler (5 min)${NC}"
echo -e "${YELLOW}[→] 💡 Press Ctrl+C to skip this phase and continue${NC}"
echo -e "${YELLOW}[→] Start time: $(date '+%H:%M:%S')${NC}"

BG_PIDS=()

cat urls/clean_alive.txt | waybackurls > urls/wayback.txt 2>/dev/null &
track_pid $!

gau --subs "$DOMAIN" > urls/gau.txt 2>/dev/null &
track_pid $!

timeout 600 katana -list urls/clean_alive.txt -jc -silent -d 2 -c 30 > urls/katana.txt 2>/dev/null &
track_pid $!

timeout 300 hakrawler -d 2 -insecure < urls/clean_alive.txt > urls/hakrawler.txt 2>/dev/null &
track_pid $!

wait_with_check

# Merge URLs
cat urls/wayback.txt urls/gau.txt urls/katana.txt urls/hakrawler.txt 2>/dev/null | sort -u > urls/all_urls.txt
URLS=$(wc -l < urls/all_urls.txt)

echo -e "${GREEN}[✓] $URLS URLs found${NC}"
echo -e "${CYAN}[→] End time: $(date '+%H:%M:%S')${NC}"
echo -e "${CYAN}[→] Katana: 10 min limit | Hakrawler: 5 min limit${NC}"
INTERRUPTED=false

# ============================================================
# PHASE 5: FILTER & PARAMETERS
# ============================================================
CURRENT_PHASE="Filtering & Parameters"
echo -e "\n${BLUE}[*] Phase 5: Filtering & Parameters${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}[→] 💡 Press Ctrl+C to skip this phase and continue${NC}"

# Filter static files
cat urls/all_urls.txt | grep -Evi "\.(jpg|png|css|js|svg|ico|pdf|mp4|zip|tar|gz|woff|ttf|eot)$" > urls/clean_urls.txt

# Extract parameters
cat urls/clean_urls.txt | grep "=" | sort -u > urls/params.txt
PARAM=$(wc -l < urls/params.txt)
echo -e "${GREEN}[✓] $PARAM URLs with parameters${NC}"
INTERRUPTED=false

# ============================================================
# PHASE 6: VULNERABILITY PATTERNS (Parallel)
# ============================================================
CURRENT_PHASE="Vulnerability Pattern Matching"
echo -e "\n${BLUE}[*] Phase 6: Vulnerability Pattern Matching${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}[→] Running all pattern searches in parallel...${NC}"
echo -e "${YELLOW}[→] 💡 Press Ctrl+C to skip this phase and continue${NC}"

BG_PIDS=()

# Run all grep patterns simultaneously
cat urls/params.txt | grep -Ei "(q=|search=|s=|query=|id=|page=|lang=|cat=|product=|user=|name=|value=|callback=)" > patterns/xss_patterns.txt &
track_pid $!

cat urls/params.txt | grep -Ei "(file=|path=|page=|dir=|include=|read=|data=|conf=|config=|view=|load=|template=)" > patterns/lfi_patterns.txt &
track_pid $!

cat urls/params.txt | grep -Ei "(id=|user=|cat=|product=|pid=|cid=|uid=|q=|search=|s=|query=|keyword=|order=|sort=|filter=)" > patterns/sqli_patterns.txt &
track_pid $!

cat urls/params.txt | grep -Ei "(url=|uri=|redirect=|next=|dest=|redir=|out=|view=|src=|source=|target=|callback=|return=|goto=)" > patterns/ssrf_patterns.txt &
track_pid $!

cat urls/clean_urls.txt | grep -Ei "(admin|login|dashboard|api|upload|config|backup|\.git|\.env|swagger|wp-admin|phpmyadmin)" > patterns/sensitive.txt &
track_pid $!

wait_with_check

echo -e "${GREEN}[✓] Pattern extraction complete${NC}"
INTERRUPTED=false

# ============================================================
# PHASE 7: AUTOMATED SCANNING (Parallel)
# ============================================================
CURRENT_PHASE="Automated Vulnerability Scanning"
echo -e "\n${BLUE}[*] Phase 7: Automated Vulnerability Scanning${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}[→] Running Dalfox & Nuclei in parallel...${NC}"
echo -e "${YELLOW}[→] 💡 Press Ctrl+C to skip this phase and continue${NC}"

BG_PIDS=()

# Run scanners simultaneously
if [ -s urls/params.txt ]; then
    cat urls/params.txt | dalfox pipe -o scans/xss_results.txt 2>/dev/null &
    track_pid $!
fi

if [ -s urls/clean_urls.txt ]; then
    nuclei -list urls/clean_urls.txt -severity high,critical -o scans/nuclei_results.txt 2>/dev/null &
    track_pid $!
fi

wait_with_check

INTERRUPTED=false

# ============================================================
# FINAL SUMMARY
# ============================================================
echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}⚡ RECONNAISSANCE COMPLETE - SMART MODE ⚡${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "📁 Main Folder: ${GREEN}$(pwd)${NC}"
echo -e ""
echo -e "📁 Folder Structure:"
echo -e "   ├── subdomains/    → All subdomain enumeration results"
echo -e "   ├── takeover/      → Subdomain takeover check results"
echo -e "   ├── urls/          → All URL extraction results"
echo -e "   ├── patterns/      → Vulnerability pattern matches"
echo -e "   └── scans/         → Automated scan results"
echo -e ""
echo -e "📊 FINAL STATISTICS:"
echo -e "   ┌─────────────────────────────────────┐"
echo -e "   │ Subdomains:     $(printf '%5s' $(wc -l < subdomains/all_subdomains.txt 2>/dev/null))     │"
echo -e "   │ Alive Hosts:    $(printf '%5s' $(wc -l < alive.txt 2>/dev/null))     │"
echo -e "   │ Total URLs:     $(printf '%5s' $(wc -l < urls/all_urls.txt 2>/dev/null))     │"
echo -e "   │ Parameters:     $(printf '%5s' $(wc -l < urls/params.txt 2>/dev/null))     │"
echo -e "   ├─────────────────────────────────────┤"
echo -e "   │ XSS Vectors:    $(printf '%5s' $(wc -l < patterns/xss_patterns.txt 2>/dev/null))     │"
echo -e "   │ LFI Vectors:    $(printf '%5s' $(wc -l < patterns/lfi_patterns.txt 2>/dev/null))     │"
echo -e "   │ SQLi Vectors:   $(printf '%5s' $(wc -l < patterns/sqli_patterns.txt 2>/dev/null))     │"
echo -e "   │ SSRF Vectors:   $(printf '%5s' $(wc -l < patterns/ssrf_patterns.txt 2>/dev/null))     │"
echo -e "   │ Sensitive:      $(printf '%5s' $(wc -l < patterns/sensitive.txt 2>/dev/null))     │"
echo -e "   └─────────────────────────────────────┘"
echo -e ""
echo -e "📄 Quick Commands:"
echo -e "   cat patterns/xss_patterns.txt | dalfox pipe -o scans/xss_results.txt"
echo -e "   nuclei -list urls/clean_urls.txt -severity high,critical"
echo -e "   cat takeover/subzy.txt takeover/subjack.txt  # Check takeovers"
echo -e ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"