#!/bin/bash

# Controlla se yay è già installato
if ! command -v yay &> /dev/null; then
    echo "yay non trovato, procedo con l'installazione..."
    # install yay
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
else
    echo "yay è già installato, proseguo con il resto dell'installazione..."
fi

yay swayfx wlogout-git

sudo pacman -S --needed \
    swaylock \
    waybar \
    rofi \
    dunst \
    wl-clipboard clipman \
    networkmanager nm-connection-editor network-manager-applet \
    blueman \
    brightnessctl \
    qt5ct qt6ct \
    thunar gvfs \
    power-profiles-daemon \
    meson make cmake ninja \
    nodejs npm \


cp -rf config/* ~/.config/

sudo usermod -aG input $USER

# set wallpaper
sudo chmod +x ~/.config/wallpaper/run.sh

pushd ~/.config/wallpaper/generate_color_palette # navigate to generate_color_palette folder
npm install
node generate_palette.js ~/.config/wallpaper/wallpaper.jpg
mv theme.rasi ~/.config/rofi/
mv colors.conf ~/.config/sway/
mv colors.css ~/.config/waybar/
popd # return to the previous directory

swaymsg reload

echo "Installazione completata."
echo "Riavvia il PC per applicare le modifiche."
read -p "Vuoi riavviare il PC? [S/n]: " risposta
if [[ -z "$risposta" ]] || [[ $risposta == "s" ]] || [[ $risposta == "S" ]]; then
    echo "Riavvio in corso..."
    sudo reboot
else
    echo "Riavvio annullato"
fi
