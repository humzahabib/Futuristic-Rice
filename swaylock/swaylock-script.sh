#!/bin/bash
# Cyberpunk lock script for swaylock-effects
# Save this as ~/.config/swaylock/lock.sh and make it executable with chmod +x

# Optional: take a screenshot and add extra effects
TMPBG="/tmp/screen_lock.png"
LOCK_ICON="$HOME/.config/swaylock/lock_icon.png"  # Optional custom lock icon

# If you have imagemagick installed, you can add extra effects
# If these commands fail, the config will still use the screenshots option
if command -v grim > /dev/null && command -v convert > /dev/null; then
    # Take screenshot
    grim -t png $TMPBG

    # Add extra effects (optional)
    # Add glitch effect
    convert $TMPBG -scale 10% -scale 1000% $TMPBG
    
    # Add scanlines
    convert $TMPBG -fill "rgba(0,221,255,0.2)" -draw "rectangle 0,0,2560,2" \
            -fill "rgba(0,0,0,0.6)" -draw "rectangle 0,2,2560,4" \
            -fill "rgba(0,0,0,0.6)" -draw "rectangle 0,6,2560,8" \
            -fill "rgba(0,0,0,0.6)" -draw "rectangle 0,10,2560,12" \
            -fill "rgba(0,0,0,0.6)" -draw "rectangle 0,14,2560,16" \
            -fill "rgba(0,0,0,0.6)" -draw "rectangle 0,18,2560,20" \
            -fill "rgba(255,0,221,0.2)" -draw "rectangle 0,1080,2560,1078" \
            -fill "rgba(0,0,0,0.6)" -draw "rectangle 0,1076,2560,1074" \
            -write $TMPBG $TMPBG
    
    # Add custom lock icon (if available)
    if [ -f "$LOCK_ICON" ]; then
        convert $TMPBG "$LOCK_ICON" -gravity center -composite $TMPBG
    fi
    
    # Launch swaylock with the processed image
    swaylock --image $TMPBG
else
    # Fallback to normal config if imagemagick is not available
    swaylock
fi

# Optionally turn off display after X seconds (requires the program 'wlopm')
# sleep 60 && wlopm --off '*' &