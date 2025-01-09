#!/bin/bash

# Scansiona le reti Wi-Fi disponibili
wifi_list=$(nmcli device wifi list --rescan yes | awk 'NR>1 {print $2}')

if [[ -z "$wifi_list" ]]; then
    echo "No Wi-Fi networks found."
    exit 1
fi

# Usa rofi per creare il menu
selected_wifi=$(echo "$wifi_list" | rofi -dmenu -p "Select Wi-Fi Network:")

# Controlla se è stata selezionata una rete
if [[ -n "$selected_wifi" ]]; then
    # Chiedi la password per la rete selezionata
    password=$(rofi -dmenu -p "Enter Password for $selected_wifi:")

    # Connetti alla rete Wi-Fi
    nmcli device wifi connect "$selected_wifi" password "$password"
else
    echo "No Wi-Fi network selected."
fi
