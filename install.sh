#!/bin/bash

# Update system
sudo pacman -Syu

# Install essential packages 
sudo pacman -S --needed --noconfirm \
    git \
    base-devel \
    xorg xorg-xinit \
    bspwm sxhkd \
    alsa-utils pulseaudio pulseaudio-alsa pavucontrol \
    networkmanager \
    polybar \
    picom \
    dunst \
    thunar gvfs \
    brightnessctl \
    ttf-nerd-fonts-symbols \
    wget \
    feh \
    lightdm lightdm-gtk-greeter


sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

sudo systemctl enable lightdm


# Install legacy audio driver
sudo mkdir -p /etc/modprobe.d && sudo cp audio-fix.conf /etc/modprobe.d/


# Install yay
if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
else
    echo "yay è già installato, proseguo con il resto dell'installazione..."
fi


# Install AMD GPU drivers
sudo pacman -S --needed --noconfirm \
    mesa \
    lib32-mesa \
    vulkan-radeon \
    lib32-vulkan-radeon \
    libva-mesa-driver \
    libva-utils


# Install build tools
sudo pacman -S --needed --noconfirm \
    cmake \
    ninja \
    meson


# Install additional packages
sudo pacman -S --needed --noconfirm \
    github-cli \
    power-profiles-daemon \
    nodejs npm 


cp -rf configs/* ~/.config/

git config --global user.email "ingenitoroby@gmail.com"
git config --global user.name "Roberto Ingenito"

echo "Installazione completata."
echo "Riavvia il sistema per applicare le modifiche."
