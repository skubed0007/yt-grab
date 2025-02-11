#!/bin/bash

# Ensure the script runs interactively
echo "Grabbing yt script and binary files for ytgui..."

# Define URLs for the necessary files
YT_SCRIPT_URL="https://raw.githubusercontent.com/skubed0007/yt-grab/main/yt"
YT_GCC_URL="https://raw.githubusercontent.com/skubed0007/yt-grab/main/bins/ytgrab-gcc"
YT_MUSL_URL="https://raw.githubusercontent.com/skubed0007/yt-grab/main/bins/ytgrab-musl"

# Define destination paths for files
YT_SCRIPT_PATH="/usr/local/bin/yt"
YT_GCC_PATH="/usr/local/bin/ytgui-gcc"
YT_MUSL_PATH="/usr/local/bin/ytgui-musl"

# Download the yt script and make it executable
echo "Downloading yt script..."
curl -s -o "$YT_SCRIPT_PATH" "$YT_SCRIPT_URL"
chmod +x "$YT_SCRIPT_PATH"

# Function to prompt for user input with a timeout or force manual interaction
prompt_choice() {
    echo "Which binary would you like to install?"
    echo "1) GCC Version"
    echo "2) MUSL Version"

    # Debugging: Ensure we are getting to the prompt
    echo "Prompting for choice..."
    while true; do
        # Debugging: Print to verify input handling
        echo "Waiting for user input..."
        
        # Capture input
        read -p "Enter choice (1 or 2): " choice
        echo "User entered: $choice"  # Debugging: Show input
        
        case $choice in
            1)
                echo "Downloading GCC version..."
                curl -s -o "$YT_GCC_PATH" "$YT_GCC_URL"
                chmod +x "$YT_GCC_PATH"
                echo "GCC version downloaded and made executable."
                sudo mv "$YT_GCC_PATH" /usr/local/bin/ytgui
                break
                ;;
            2)
                echo "Downloading MUSL version..."
                curl -s -o "$YT_MUSL_PATH" "$YT_MUSL_URL"
                chmod +x "$YT_MUSL_PATH"
                echo "MUSL version downloaded and made executable."
                sudo mv "$YT_MUSL_PATH" /usr/local/bin/ytgui
                break
                ;;
            *)
                echo "Invalid choice. Please enter 1 or 2."
                ;;
        esac
    done
}

# Run the prompt for binary selection
prompt_choice

# Final message
echo "ytgui has been successfully installed and placed in /usr/local/bin/ytgui."
echo "Please make sure yt-dlp is installed for better experience."
echo "You can install yt-dlp using 'pip install yt-dlp' or 'apt install yt-dlp' (depending on your system)."
