#!/bin/bash

# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display the menu
show_menu() {
    echo -e "${GREEN}Welcome to the User Menu${NC}"
    echo -e "${YELLOW}1.${NC} ${BLUE}Update Bot Data${NC}"
    echo -e "${YELLOW}2.${NC} ${BLUE}Option 2${NC}"
    echo -e "${YELLOW}3.${NC} ${BLUE}Option 3${NC}"
    echo -e "${YELLOW}4.${NC} ${BLUE}Exit${NC}"
}

# URL to send the POST request to
URL="https://api.hamsterkombat.io/clicker/claim-daily-cipher" # Replace with the actual URL

# JSON data to be sent in the POST request
DATA='{"cipher":"SWAP"}'

# Send the POST request using curl
curl -X POST $URL \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer 1718921828436i88dkbR7Iu3Pgd2BSLMj7J0iwDLob4fuIAAlhnzpUaczMVBAafJnW4OvPflTUdQi1599637373" \
    -H "Accept: application/json" \
    -H "Accept-Language: en-US,en;q=0.9" \
    -H "Referer: https://hamsterkombat.io/" \
    -H "Origin: https://hamsterkombat.io" \
    -H "Connection: keep-alive" \
    -H "Sec-Fetch-Dest: empty" \
    -H "Sec-Fetch-Mode: cors" \
    -H "Sec-Fetch-Site: same-site" \
    -H "Priority: u=4" \
    -d "$DATA"

get_config() {
    # URL to send the GET request to
    CONFIG_URL="https://nabikaz.github.io/HamsterKombat-API/config.json"

    # Send the GET request using curl and show the response
    RESPONSE=$(curl -s -X GET $CONFIG_URL)

    # Parse the morseCode and dailyCards values from the response
    MORSE_CODE=$(echo $RESPONSE | jq -r '.morseCode')
    DAILY_CARDS=$(echo $RESPONSE | jq -r '.dailyCards[]')

    # Print the parsed values
    echo "Morse Code: $MORSE_CODE"
    echo "Daily Cards: $DAILY_CARDS"
}

# Function to read user's choice
read_choice() {
    read -p "Enter your choice [1-4]: " choice
    case $choice in
        1)
            get_config
            ;;
        2) echo -e "${RED}You chose Option 2${NC}" ;;
        3) echo -e "${RED}You chose Option 3${NC}" ;;
        4) exit 0 ;;
        *) echo -e "${RED}Invalid choice${NC}" ;;
    esac
}

# Main loop
while true; do
    show_menu
    read_choice
done