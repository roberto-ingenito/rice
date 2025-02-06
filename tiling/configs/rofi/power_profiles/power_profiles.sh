#!/bin/bash

# Ottieni il profilo corrente
current_profile=$(powerprofilesctl get)

# Lista dei profili disponibili
profiles='performance\nbalanced\npower-saver'

# Aggiungi il profilo corrente come prima opzione (non selezionabile)
menu="Profilo attivo: $current_profile"

# Usa Rofi per selezionare il profilo
selected_profile=$(echo -e "$profiles" | rofi -dmenu -mesg "$menu" -theme ~/.config/rofi/power_profiles/style.rasi)

# Se l'utente seleziona un profilo diverso da quello attivo, applicalo
if [ -n "$selected_profile" ]; then
    powerprofilesctl set $selected_profile
fi
