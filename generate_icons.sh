#!/bin/bash

# Create a temporary directory
mkdir -p temp_icons

# Copy the original icon
cp "pngimg.com - letter_j_PNG12.png" temp_icons/original.png

# Generate all required sizes
sips -z 40 40 temp_icons/original.png --out temp_icons/Icon-20@2x.png
sips -z 60 60 temp_icons/original.png --out temp_icons/Icon-20@3x.png
sips -z 58 58 temp_icons/original.png --out temp_icons/Icon-29@2x.png
sips -z 87 87 temp_icons/original.png --out temp_icons/Icon-29@3x.png
sips -z 80 80 temp_icons/original.png --out temp_icons/Icon-40@2x.png
sips -z 120 120 temp_icons/original.png --out temp_icons/Icon-40@3x.png
sips -z 120 120 temp_icons/original.png --out temp_icons/Icon-60@2x.png
sips -z 180 180 temp_icons/original.png --out temp_icons/Icon-60@3x.png
sips -z 1024 1024 temp_icons/original.png --out temp_icons/Icon-1024.png

# Copy all icons to the AppIcon.appiconset directory
cp temp_icons/Icon-*.png JokerGame/JokerGame/Assets.xcassets/AppIcon.appiconset/

# Clean up
rm -rf temp_icons 