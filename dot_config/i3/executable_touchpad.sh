#!/bin/bash

# Get the device ID of your touchpad (replace "Touchpad" with the name of your touchpad device if needed)
TOUCHPAD_ID=$(xinput list --id-only "SYNA8018:00 06CB:CE67 Touchpad")

# Enable tap-to-click
xinput set-prop $TOUCHPAD_ID "libinput Tapping Enabled" 1

# Enable disable-while-typing
xinput set-prop $TOUCHPAD_ID "libinput Disable While Typing Enabled" 1

# Enable natural scrolling
xinput set-prop $TOUCHPAD_ID "libinput Natural Scrolling Enabled" 1

# Set pointer acceleration
xinput set-prop $TOUCHPAD_ID "libinput Accel Speed" 0.3

