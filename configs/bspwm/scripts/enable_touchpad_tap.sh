#!/bin/bash

# Enable the touchpad tap
touchpad_id=$(xinput list | grep -i "touchpad" | sed -n 's/.*id=\([0-9]*\).*/\1/p')
xinput set-prop $touchpad_id "libinput Tapping Enabled" 1