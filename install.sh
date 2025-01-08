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
    sof-firmware alsa-firmware alsa-ucm-conf \
    networkmanager \
    polybar \
    picom \
    dunst \
    thunar gvfs \
    brightnessctl \
    ttf-nerd-fonts-symbols \
    wget \
    feh \
    lightdm lightdm-gtk-greeter lightdm-webkit2-greeter \
    lxappearance


sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

sudo systemctl enable lightdm

# [NOT WORK] Set lighdm theme
# mkdir -p glorious
# mv theme.tar.gz glorious/
# cd glorious
# tar zxvf theme.tar.gz
# mv theme.tar.gz ../
# cd ..
# sudo mv glorious/ /usr/share/lightdm-webkit/themes/
# sudo sed -i 's/^webkit_theme.*/webkit_theme = glorious/' /etc/lightdm/lightdm-webkit2-greeter.conf


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

cp -rf configs/* ~/.config/

git config --global user.email "ingenitoroby@gmail.com"
git config --global user.name "Roberto Ingenito"

# Remove timeout from bootloader
sudo sed -i 's/^timeout.*/timeout 0/' /boot/loader/loader.conf

# Install fonts
sudo cp ./configs/rofi/JetBrains-Mono-Nerd-Font-Complete.ttf /usr/share/fonts/
sudo cp ./configs/rofi/Icomoon-Feather.ttf /usr/share/fonts/
fc-cache -fv

# Install theme
sudo tar -xJf Nordic.tar.xz -C /usr/share/themes/


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

echo "Installazione completata."
echo "Imposta il tema con lxappearance"
echo "Riavvia il sistema per applicare le modifiche."
