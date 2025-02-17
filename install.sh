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
sudo chmod +x "$YT_SCRIPT_PATH"

# Automatically detect whether the system uses GCC or MUSL
if ldd --version &>/dev/null; then
    # If ldd is available, check for GCC-based systems
    print_msg "GCC system detected."
    download_url="$YT_GCC_URL"
    binary_path="$YT_GCC_PATH"
else
    # If ldd is not available, assume a MUSL-based system
    print_msg "MUSL system detected."
    download_url="$YT_MUSL_URL"
    binary_path="$YT_MUSL_PATH"
fi

# Download the appropriate binary
print_msg "Downloading the appropriate binary..."
curl -s -o "$binary_path" "$download_url"
sudo chmod +x "$binary_path"

# Move the binary to the right location
sudo mv "$binary_path" /usr/local/bin/ytgui

# Final message
print_msg "ytgui has been successfully installed and placed in /usr/local/bin/ytgui."
print_msg "Please make sure yt-dlp is installed for a better experience."
print_msg "You can install yt-dlp using 'pip install yt-dlp' or 'apt install yt-dlp' (depending on your system)."
