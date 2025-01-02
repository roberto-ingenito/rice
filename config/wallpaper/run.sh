#!/bin/bash

# Impostare il percorso dell'immagine di sfondo
IMAGE_PATH="~/.config/wallpaper/wallpaper"

# Espandere la tilde (~) in modo che venga correttamente interpretato
IMAGE_PATH=$(eval echo $IMAGE_PATH)

# Verifica se il file esiste e impostarlo come sfondo
if [[ -f "$IMAGE_PATH.jpg" ]]; then
    swaymsg "output * background $IMAGE_PATH.jpg fill"
elif [[ -f "$IMAGE_PATH.jpeg" ]]; then
    swaymsg "output * background $IMAGE_PATH.jpeg fill"
elif [[ -f "$IMAGE_PATH.png" ]]; then
    swaymsg "output * background $IMAGE_PATH.png fill"
else
    echo "Nessun file immagine trovato! Usa un file .jpg, .jpeg o .png."
    exit 1
fi
