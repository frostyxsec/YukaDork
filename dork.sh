#!/bin/bash

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display help
show_help() {
    echo "
    
██╗░░░██╗██╗░░░██╗██╗░░██╗░█████╗░██████╗░░█████╗░██████╗░██╗░░██╗
╚██╗░██╔╝██║░░░██║██║░██╔╝██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║░██╔╝
░╚████╔╝░██║░░░██║█████═╝░███████║██║░░██║██║░░██║██████╔╝█████═╝░
░░╚██╔╝░░██║░░░██║██╔═██╗░██╔══██║██║░░██║██║░░██║██╔══██╗██╔═██╗░
░░░██║░░░╚██████╔╝██║░╚██╗██║░░██║██████╔╝╚█████╔╝██║░░██║██║░╚██╗
░░░╚═╝░░░░╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═════╝░░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝"
    echo -e "${BLUE}Google Dorking Tool${NC}"
    echo "Usage: $0 -d <domain> -o <output_file>"
    echo "  -d  Target domain to perform Google dorking on"
    echo "  -o  Output file to save results"
    echo "  -h  Display this help message"
    exit 1
}

# Function to display banner
show_banner() {
    echo -e "${RED}"
    echo "
    
██╗░░░██╗██╗░░░██╗██╗░░██╗░█████╗░██████╗░░█████╗░██████╗░██╗░░██╗
╚██╗░██╔╝██║░░░██║██║░██╔╝██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║░██╔╝
░╚████╔╝░██║░░░██║█████═╝░███████║██║░░██║██║░░██║██████╔╝█████═╝░
░░╚██╔╝░░██║░░░██║██╔═██╗░██╔══██║██║░░██║██║░░██║██╔══██╗██╔═██╗░
░░░██║░░░╚██████╔╝██║░╚██╗██║░░██║██████╔╝╚█████╔╝██║░░██║██║░╚██╗
░░░╚═╝░░░░╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═════╝░░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝"
    echo -e "${NC}"
    echo -e "${YELLOW}Google Dorking Made Easy${NC}"
    echo -e "${GREEN}Author: Security Researcher${NC}"
    echo ""
}

# Check if required commands are available
check_requirements() {
    command -v curl >/dev/null 2>&1 || { echo -e "${RED}Error: curl is required but not installed.${NC}" >&2; exit 1; }
    command -v grep >/dev/null 2>&1 || { echo -e "${RED}Error: grep is required but not installed.${NC}" >&2; exit 1; }
    command -v jq >/dev/null 2>&1 || { echo -e "${YELLOW}Warning: jq is not installed. Some features may not work properly.${NC}" >&2; }
}

# Check if no arguments were provided
if [ $# -eq 0 ]; then
    show_help
fi

# Parse command line arguments
while getopts "d:o:h" opt; do
    case ${opt} in
        d )
            domain=$OPTARG
            ;;
        o )
            output=$OPTARG
            ;;
        h )
            show_help
            ;;
        \? )
            echo "Invalid option: $OPTARG" 1>&2
            show_help
            ;;
        : )
            echo "Invalid option: $OPTARG requires an argument" 1>&2
            show_help
            ;;
    esac
done

# Check if required arguments are provided
if [ -z "$domain" ] || [ -z "$output" ]; then
    echo -e "${RED}Error: Domain and output file are required.${NC}" 1>&2
    show_help
fi

check_requirements
show_banner

# Create the output file and add a header
echo "# Google Dorking Results for $domain" > "$output"
echo "# Generated on $(date)" >> "$output"
echo "# ===========================================" >> "$output"
echo "" >> "$output"

# Function to URL encode a string
url_encode() {
    # More robust URL encoding
    echo "$1" | sed -e 's/ /%20/g' \
                    -e 's/:/%3A/g' \
                    -e 's/"/%22/g' \
                    -e 's/|/%7C/g' \
                    -e 's/(/%28/g' \
                    -e 's/)/%29/g' \
                    -e 's/\[/%5B/g' \
                    -e 's/\]/%5D/g' \
                    -e 's/=/%3D/g' \
                    -e 's/&/%26/g' \
                    -e 's/+/%2B/g' \
                    -e 's/#/%23/g' \
                    -e 's/@/%40/g' \
                    -e 's/\$/%24/g' \
                    -e 's/;/%3B/g'
}

# Generate random User-Agent
get_random_user_agent() {
    user_agents=(
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36"
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.67 Safari/537.36"
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 12_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Safari/605.1.15"
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:100.0) Gecko/20100101 Firefox/100.0"
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36"
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Edge/100.0.1185.50"
    )
    echo "${user_agents[$RANDOM % ${#user_agents[@]}]}"
}

# Function to perform Google dorking using curl with improved parsing
perform_dork() {
    local query="$1"
    local user_agent=$(get_random_user_agent)
    
    # Encode the query for URL
    local encoded_query=$(url_encode "$query")
    local search_url="https://www.google.com/search?q=$encoded_query&num=100"
    
    # Add a random delay to prevent rate limiting (between 3-7 seconds)
    sleep_time=$(( RANDOM % 5 + 3 ))
    echo -e "${YELLOW}Waiting ${sleep_time}s before next query (anti-rate limiting)...${NC}"
    sleep $sleep_time
    
    # Record the query in the output file
    echo -e "## Query: $query" >> "$output"
    echo -e "" >> "$output"
    
    # Fetch results using curl with improved options
    echo -e "${BLUE}Fetching results from Google...${NC}"
    local response=$(curl -s -A "$user_agent" -H "Accept-Language: en-US,en;q=0.9" \
                         -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" \
                         --compressed "$search_url")
    
    # Extract URLs from Google search results (improved pattern)
    local results=$(echo "$response" | grep -o '<a href="[^"]*" ping="[^"]*"' | grep -v "google.com" | \
                   sed 's/<a href="//g' | sed 's/" ping="[^"]*"//g' | grep "^http" | sort -u)
    
    # If we didn't get results with the first pattern, try alternate patterns
    if [ -z "$results" ]; then
        results=$(echo "$response" | grep -o '<a href="https\?://[^"]*"' | grep -v "google.com" | \
                 sed 's/<a href="//g' | sed 's/"//g' | grep "^http" | sort -u)
    fi
    
    # If we still don't have results, try another pattern
    if [ -z "$results" ]; then
        results=$(echo "$response" | grep -o 'class=".*"><a href="[^"]*"' | grep -v "google.com" | \
                 sed 's/.*<a href="//g' | sed 's/"//g' | grep "^http" | sort -u)
    fi
    
    # Display results in the terminal and save to file
    if [ -z "$results" ]; then
        echo -e "${YELLOW}No results found for this query or Google may be blocking automated requests.${NC}"
        echo -e "${BLUE}Saving query for manual investigation.${NC}"
        echo "No automated results found. Try this search manually: https://www.google.com/search?q=$encoded_query" >> "$output"
    else
        result_count=$(echo "$results" | wc -l)
        echo -e "${GREEN}Found $result_count results!${NC}"
        
        echo "$results" | while read -r line; do
            if [ -n "$line" ]; then
                echo -e "  - ${BLUE}$line${NC}"
                echo "  - $line" >> "$output"
            fi
        done
    fi
    
    echo -e "" >> "$output"
    echo -e "" >> "$output"
}

# Array of Google dork queries (same as original script)
declare -a dork_queries=(
    # Finding Exposed Files & Directories
    "intitle:\"index of\" site:$domain"
    "site:$domain ext:log | ext:txt | ext:conf"
    "site:$domain ext:sql | ext:db"
    "site:$domain inurl:backup | inurl:old | inurl:bak"
    "site:$domain intitle:\"Index of /\" \"password\""
    "intitle:\"index of /private\" site:$domain"
    "site:$domain inurl:\"/uploads\" -intext:\"no such\""
    "site:$domain inurl:\"backup.zip\" | inurl:\"database.sql\""
    "site:$domain inurl:\".ssh\" | inurl:\"id_rsa\""
    "site:$domain \"Index of\" \"parent directory\" \"config\""
    "site:$domain inurl:/uploads intitle:index.of"
    "site:$domain inurl:/private | inurl:/confidential"
    "site:$domain ext:swp | ext:bak | ext:old"
    "site:$domain inurl:temp | inurl:cache | inurl:old"
    "site:$domain \"Index of /\" \"userdata\""
    
    # Finding Sensitive Credentials
    "site:$domain inurl:wp-config.php"
    "site:$domain filetype:env \"DB_PASSWORD\""
    "site:$domain \"password\" filetype:xls | filetype:csv | filetype:txt"
    "site:$domain \"API_KEY\" | \"secret\" | \"token\""
    "site:$domain intext:\"password=\""
    "site:$domain filetype:json \"aws_secret_access_key\""
    "site:$domain filetype:log \"admin password\""
    "site:$domain filetype:ini \"smtp_password\""
    "site:$domain filetype:conf \"vpn_password\""
    "site:$domain \"Authorization: Bearer\""
    "site:$domain ext:ini \"mysql_password\""
    "site:$domain \"BEGIN RSA PRIVATE KEY\""
    "site:$domain \"Authorization: Basic\""
    "site:$domain filetype:cfg \"admin_password\""
    "site:$domain \"ftp://\" intext:\"@\""
    
    # Finding Login Pages & Admin Panels
    "site:$domain inurl:admin"
    "site:$domain inurl:login"
    "site:$domain intitle:\"admin login\""
    "site:$domain inurl:\"phpmyadmin\" | intitle:\"phpmyadmin\""
    "site:$domain inurl:dashboard"
    "site:$domain inurl:\"/cpanel\""
    "site:$domain inurl:/admin/login"
    "site:$domain inurl:/user/login"
    "site:$domain intitle:\"control panel\""
    "site:$domain inurl:signin | inurl:auth"
    "site:$domain inurl:\"/admin/login.jsp\""
    "site:$domain inurl:\"/login.php?redirect=\""
    "site:$domain inurl:\"/controlpanel\""
    "site:$domain intitle:\"webmail login\""
    "site:$domain \"Please enter your username and password\""

    # More dorks from original script...
    # Only showing some dorks for brevity - include all your original dorks here
)

total_dorks=${#dork_queries[@]}
count=0

echo -e "${BLUE}Starting Google dorking for $domain...${NC}"
echo -e "${YELLOW}Total queries to run: $total_dorks${NC}"
echo -e "${GREEN}Results will be saved to: $output${NC}"
echo ""
echo -e "${RED}Important: Google may detect automated searches and block requests.${NC}"
echo -e "${RED}If you see 'No results' for all queries, try:${NC}"
echo -e "${RED}1. Running fewer queries at once${NC}"
echo -e "${RED}2. Using a VPN or proxy${NC}"
echo -e "${RED}3. Adding longer delays between queries${NC}"
echo -e "${RED}4. Running queries manually using the saved search URLs${NC}"
echo ""

# Execute each dork query
for query in "${dork_queries[@]}"; do
    count=$((count + 1))
    percentage=$((count * 100 / total_dorks))
    
    echo -e "${YELLOW}[$percentage%] ${GREEN}Running query (${count}/$total_dorks): ${BLUE}$query${NC}"
    perform_dork "$query"
    
    # Progress bar
    bar_size=50
    filled_size=$((percentage * bar_size / 100))
    bar="["
    for ((i=0; i<filled_size; i++)); do
        bar+="#"
    done
    for ((i=filled_size; i<bar_size; i++)); do
        bar+="."
    done
    bar+="] $percentage%"
    echo -e "${GREEN}$bar${NC}"
    echo ""
done

echo -e "${GREEN}Google dorking completed!${NC}"
echo -e "${BLUE}Results have been saved to: $output${NC}"
echo -e "${YELLOW}Note: If most queries returned 'No results', Google may have detected automation.${NC}"
echo -e "${YELLOW}Review the output file for search URLs to try manually.${NC}"
echo -e "${RED}Warning: Use this tool responsibly and only on domains you own or have permission to test.${NC}"

exit 0
