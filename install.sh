#!/bin/bash

# Function to print the colored text
print_msg() {
    echo -e "\033[1;32m$1\033[0m"
}

# Function to print the error message in red
print_error() {
    echo -e "\033[1;31m$1\033[0m"
}

# Ensure the script runs interactively
print_msg "Grabbing yt script and binary files for ytgui..."

# Define URLs for the necessary files
YT_SCRIPT_URL="https://raw.githubusercontent.com/skubed0007/yt-grab/main/yt"
YT_GCC_URL="https://raw.githubusercontent.com/skubed0007/yt-grab/main/bins/ytgrab-gcc"
YT_MUSL_URL="https://raw.githubusercontent.com/skubed0007/yt-grab/main/bins/ytgrab-musl"

# Define destination paths for files
YT_SCRIPT_PATH="/usr/local/bin/yt"
YT_GCC_PATH="/usr/local/bin/ytgui-gcc"
YT_MUSL_PATH="/usr/local/bin/ytgui-musl"

# Download the yt script and make it executable
print_msg "Downloading yt script..."
curl -s -o "$YT_SCRIPT_PATH" "$YT_SCRIPT_URL"
chmod +x "$YT_SCRIPT_PATH"

# Ask for binary choice
print_msg "Which binary would you like to install?"
print_msg "1) GCC Version"
print_msg "2) MUSL Version"

while true; do
    read -p "Enter choice (1 or 2): " choice
    if [[ "$choice" == "1" ]]; then
        print_msg "Downloading GCC version..."
        curl -s -o "$YT_GCC_PATH" "$YT_GCC_URL"
        chmod +x "$YT_GCC_PATH"
        print_msg "GCC version downloaded and made executable."
        
        # Moving the binary to the right location
        sudo mv "$YT_GCC_PATH" /usr/local/bin/ytgui
        break
    elif [[ "$choice" == "2" ]]; then
        print_msg "Downloading MUSL version..."
        curl -s -o "$YT_MUSL_PATH" "$YT_MUSL_URL"
        chmod +x "$YT_MUSL_PATH"
        print_msg "MUSL version downloaded and made executable."
        
        # Moving the binary to the right location
        sudo mv "$YT_MUSL_PATH" /usr/local/bin/ytgui
        break
    else
        print_error "Invalid choice. Please enter 1 or 2."
    fi
done

# Final message
print_msg "ytgui has been successfully installed and placed in /usr/local/bin/ytgui."
print_msg "Please make sure yt-dlp is installed for a better experience."
print_msg "You can install yt-dlp using 'pip install yt-dlp' or 'apt install yt-dlp' (depending on your system)."
