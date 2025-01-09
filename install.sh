#!/bin/bash

sudo sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 10/' /etc/pacman.conf

# Update system
sudo pacman -Syu


# Install essential packages 
sudo pacman -S --needed --noconfirm \
    git \
    kitty \
    rofi \
    base-devel \
    xorg xorg-xinit \
    bspwm sxhkd \
    alsa-utils pavucontrol \
    sof-firmware alsa-firmware alsa-ucm-conf \
    polybar \
    picom \
    dunst \
    thunar gvfs \
    brightnessctl \
    ttf-nerd-fonts-symbols \
    wget \
    feh \
    sddm \
    lxappearance \
    libreoffice-fresh


# Install sddm theme
# qt5-quickcontrols qt5-quickcontrols2 qt5-graphicaleffects qt5-svg qt6
sudo pacman -S --needed --noconfirm breeze-gtk kdeplasma-addons
tar xJf Apple-Sequoia-v1.Plasma6.tar.xz
sudo mkdir -p /usr/share/sddm/themes/ && sudo cp -r Apple-Sequoia-v1.Plasma6 /usr/share/sddm/themes/
echo "[Theme]
Current=Apple-Sequoia-v1.Plasma6" | sudo tee /etc/sddm.conf > /dev/null
rm -rf Apple-Sequoia-v1.Plasma6/
sudo systemctl enable sddm


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


# Install AUR packages
yay -S --rebuildall --rebuildtree --noconfirm \
    visual-studio-code-bin \
    android-studio \
    google-chrome


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


# Add user to audio group
sudo usermod -aG audio $USER


# Set git user
git config --global user.email "ingenitoroby@gmail.com"
git config --global user.name "Roberto Ingenito"


# Remove timeout from bootloader
sudo sed -i 's/^timeout.*/timeout 0/' /boot/loader/loader.conf


# Install fonts
sudo cp ./configs/rofi/JetBrains-Mono-Nerd-Font-Complete.ttf /usr/share/fonts/
sudo cp ./configs/rofi/Icomoon-Feather.ttf /usr/share/fonts/
fc-cache -fv


# Set the swapfile for hibernation mode
sudo fallocate -l 16G /swapfile
sudo chmod 600 /swapfile 
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab > /dev/null
sudo sed -i '/^HOOKS=/s/)/ resume)/' /etc/mkinitcpio.conf
sudo mkinitcpio -P
sudo filefrag -v /swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}' | sudo tee /sys/power/resume_offset > /dev/null
sudo cp sleep.conf /etc/systemd/
sudo cp logind.conf /etc/systemd/


# Install dotfiles
cp -rf configs/* ~/.config/


echo "Installazione completata."
echo "Imposta il tema con lxappearance"
echo "Riavvia il sistema per applicare le modifiche."
