#!/bin/bash

# Convert SVG assets to PNG format
# Requires: imagemagick or inkscape

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if we have a converter
if command -v convert &> /dev/null; then
    CONVERTER="convert"
elif command -v inkscape &> /dev/null; then
    CONVERTER="inkscape"
else
    echo -e "${RED}Error: Neither ImageMagick nor Inkscape is installed.${NC}"
    echo "Please install one of them to convert SVG files:"
    echo "  sudo pacman -S imagemagick"
    echo "  or"
    echo "  sudo pacman -S inkscape"
    exit 1
fi

# Convert function
convert_svg_to_png() {
    local svg_file="$1"
    local png_file="${svg_file%.svg}.png"
    
    echo -e "${YELLOW}Converting:${NC} $svg_file -> $png_file"
    
    if [ "$CONVERTER" = "convert" ]; then
        convert -background none "$svg_file" "$png_file"
    else
        inkscape -z -e "$png_file" "$svg_file"
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Success:${NC} Created $png_file"
    else
        echo -e "${RED}Error:${NC} Failed to convert $svg_file"
    fi
}

# Process all SVG files in the themes directory
process_theme() {
    local theme="$1"
    echo -e "${GREEN}Processing ${YELLOW}$theme${GREEN} theme assets...${NC}"
    
    # Find all SVG files in the theme directory
    find ~/.config/hypr/themes/$theme/assets -name "*.svg" | while read svg_file; do
        convert_svg_to_png "$svg_file"
    done
}

# Convert all themes or specific ones
if [ $# -eq 0 ]; then
    # Convert all themes
    for theme_dir in ~/.config/hypr/themes/*/; do
        theme=$(basename "$theme_dir")
        process_theme "$theme"
    done
else
    # Convert specified themes
    for theme in "$@"; do
        if [ -d ~/.config/hypr/themes/$theme ]; then
            process_theme "$theme"
        else
            echo -e "${RED}Error:${NC} Theme directory '$theme' not found"
        fi
    done
fi

echo -e "${GREEN}All conversions completed!${NC}"
