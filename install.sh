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
    echo -e "${YELLOW}2.${NC} ${BLUE}Get daily cipher${NC}"
    echo -e "${YELLOW}3.${NC} ${BLUE}Get daily reward (Only use once a day!)${NC}"
    echo -e "${YELLOW}4.${NC} ${BLUE}Get daily combo${NC}"
    echo -e "${YELLOW}0.${NC} ${BLUE}Exit${NC}"
}

# Update bot inits
updateInit() {
    # URL to send the GET request to
    CONFIG_URL="https://nabikaz.github.io/HamsterKombat-API/config.json"

    # Send the GET request using curl and show the response
    RESPONSE=$(curl -s -X GET $CONFIG_URL)

    # Parse the morseCode and dailyCards values from the response
    MORSE_CODE=$(echo $RESPONSE | jq -r '.morseCode')
    DAILY_CARD1=$(echo $RESPONSE | jq -r '.dailyCards[0]')
    DAILY_CARD2=$(echo $RESPONSE | jq -r '.dailyCards[1]')
    DAILY_CARD3=$(echo $RESPONSE | jq -r '.dailyCards[2]')

    # Print the parsed values
    echo "Morse Code: $MORSE_CODE"
    echo "Daily Cards: $DAILY_CARDS"
}

# Function to claim the daily cipher
cipher() {
    # Ask the user to enter the Authorization
    read -p "Enter the Authorization: " AUTHORIZATION

    # URL to send the POST request to
    URL="https://api.hamsterkombat.io/clicker/claim-daily-cipher"

    # JSON data to be sent in the POST request
    DATA="{\"cipher\":\"$MORSE_CODE\"}"

    # Send the POST request curl and save the HTTP status code and response body
    RESPONSE=$(curl -s -w "\n%{http_code}\n" -X POST $URL \
        -H "Content-Type: application/json" \
        -H "Authorization: $AUTHORIZATION" \
        -H "Accept: application/json" \
        -H "Accept-Language: en-US,en;q=0.9" \
        -H "Referer: https://hamsterkombat.io/" \
        -H "Origin: https://hamsterkombat.io" \
        -H "Connection: keep-alive" \
        -H "Sec-Fetch-Dest: empty" \
        -H "Sec-Fetch-Mode: cors" \
        -H "Sec-Fetch-Site: same-site" \
        -H "Priority: u=4" \
        -d "$DATA")

    # Extract the HTTP status code from the last line of the response
    STATUS_CODE=$(echo "$RESPONSE" | tail -n 1)

    # Remove the HTTP status code from the response body
    RESPONSE_BODY=$(echo "$RESPONSE" | sed '$d')

    # Check the HTTP status code and print a message
    if [ $STATUS_CODE -eq 200 ]; then
        echo "Operation successful."
    elif [ $STATUS_CODE -eq 400 ]; then
        # Check the response body for the specific error code
        if echo "$RESPONSE_BODY" | grep -q '"error_code": "DAILY_CIPHER_DOUBLE_CLAIMED"'; then
            # Extract the error message from the response body
            ERROR_MESSAGE=$(echo "$RESPONSE_BODY" | grep -oP '(?<="error_message": ")[^"]*')
            echo "Error: $ERROR_MESSAGE"
        else
            echo "Operation failed: $RESPONSE_BODY"
        fi
    else
        echo "Unexpected status code: $STATUS_CODE"
    fi

}

# Function to claim the daily reward
dailyStreak() {
    # Ask the user to enter the Authorization
    read -p "Enter the Authorization: " AUTHORIZATION

    # URL to send the POST request to
    URL="https://api.hamsterkombat.io/clicker/check-task"

    # JSON data to be sent in the POST request
    DATA="{\"taskId\":\"streak_days\"}"

    # Send the POST request curl and save the HTTP status code and response body
    RESPONSE=$(
        curl -s -w "\n%{http_code}\n" -X POST $URL \
            -H "User-Agent: Mozilla/5.0 (Android 12; Mobile; rv:102.0) Gecko/102.0 Firefox/102.0" \
            -H "Content-Type: application/json" \
            -H "Authorization: $AUTHORIZATION" \
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
    )

    # Extract the HTTP status code from the last line of the response
    STATUS_CODE=$(echo "$RESPONSE" | tail -n 1)

    # Check the HTTP status code and print a message
    if [ $STATUS_CODE -eq 200 ]; then
        echo "Operation successful."
    else
        # Remove the HTTP status code from the response body
        RESPONSE_BODY=$(echo "$RESPONSE" | sed '$d')
        echo "Operation failed with status code: $STATUS_CODE : $RESPONSE_BODY"
    fi

}

# Function to buy daily combo cards
# dailyCombo(){

# }

# Function to read user's choice
read_choice() {
    read -p "Enter your choice [1-4]: " choice
    case $choice in
    1)
        updateInit
        ;;
    2)
        cipher
        ;;
    3)
        dailyStreak
        ;;

    4)
        # dailyCombo
        # ;;

    0) exit 0 ;;
    *) echo -e "${RED}Invalid choice${NC}" ;;
    esac
}

# Main loop
while true; do
    show_menu
    read_choice
done
