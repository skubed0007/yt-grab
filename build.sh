#!/bin/bash

# Define the target platforms
declare -A targets=(
    ["musl-linux"]="x86_64-unknown-linux-musl"
    ["gcc-linux"]="x86_64-unknown-linux-gnu"
)

# Create the output directory (bins folder)
output_dir="bins"
mkdir -p "$output_dir"

# Build for each target
for platform in "${!targets[@]}"; do
    target="${targets[$platform]}"
    echo "Building for target: $target"
    
    # Run the cargo build command for the target
    cargo build --release --target "$target"
    
    # Check if the build was successful
    if [ $? -eq 0 ]; then
        echo "Build successful for $target"
        
        # Define binary name and source path
        binary_name="ytgui"  # Replace with your binary name
        target_dir="target/$target/release"
        source_path="$target_dir/$binary_name"
        
        # Check if the binary exists
        if [ -f "$source_path" ]; then
            # Determine the short name for the binary
            case "$platform" in
                "musl-linux")
                    short_name="ytgui-musl"
                    ;;
                "gcc-linux")
                    short_name="ytgui-gcc"
                    ;;
                "windows-x86")
                    short_name="ytgui-win32.exe"
                    ;;
                "windows-x64")
                    short_name="ytgui-win64.exe"
                    ;;
                *)
                    echo "Unknown platform: $platform"
                    exit 1
                    ;;
            esac
            
            # Copy the binary to the bins directory
            cp "$source_path" "$output_dir/$short_name"
            echo "Copied to: $output_dir/$short_name"
        else
            echo "Error: Binary not found at $source_path"
        fi
    else
        echo "Build failed for $target"
    fi
done

echo "Build and copy process complete!"
