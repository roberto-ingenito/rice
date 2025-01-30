#!/bin/bash

export DISPLAY=:0
export XAUTHORITY=$(ls -lt /tmp/xauth_* | grep " $USER " | head -n 1 | awk '{print $NF}')

# Lancia i3lock
~/.config/rofi/powermenu/lock.sh

# Prendi input dal parametro dello script
action=$1

case "$action" in
    suspend)
        # Sospendi il sistema
        systemctl suspend
        ;;
    hibernate)
        # Iberna il sistema
        systemctl hibernate
        ;;
    *)
        echo "Azione non valida. Usa 'suspend' o 'hibernate'."
        ;;
esac
