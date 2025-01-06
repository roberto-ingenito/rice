#!/bin/bash
options="Logout\nReboot\nShutdown"
choice=$(echo -e $options | rofi -dmenu -i -p "Power Menu:")
case $choice in
    Logout) loginctl terminate-session $XDG_SESSION_ID ;;
    Reboot) systemctl reboot ;;
    Shutdown) systemctl poweroff ;;
esac
