#!/bin/bash


# set pacman to install packages in parallel
sudo sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 10/' /etc/pacman.conf


# Update system
sudo pacman -Syu


# Install essential packages 
sudo pacman -S --needed --noconfirm \
    base-devel cmake ninja meson \
    rofi polybar picom dunst feh sddm \
    git github-cli \
    power-profiles-daemon python-gobject gobject-introspection \
    kitty \
    xorg xorg-xinit \
    bspwm sxhkd \
    alsa-utils pavucontrol \
    sof-firmware alsa-firmware alsa-ucm-conf \
    thunar gvfs \
    brightnessctl \
    ttf-nerd-fonts-symbols \
    wget \
    lxappearance \
    libreoffice-fresh \
    nodejs npm \
    acpid polkit


# Enable the Power Profile Daemon service to start automatically at boot time
sudo systemctl enable power-profiles-daemon


# Install sddm theme
# qt5-quickcontrols qt5-quickcontrols2 qt5-graphicaleffects qt5-svg qt6
sudo pacman -S --needed --noconfirm breeze-gtk kdeplasma-addons
tar -xzf Apple-Sequoia-v1.Plasma6.tar.gz
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
    google-chrome \
    i3lock-color


# Install AMD GPU drivers
sudo pacman -S --needed --noconfirm \
    mesa \
    lib32-mesa \
    vulkan-radeon \
    lib32-vulkan-radeon \
    libva-mesa-driver \
    libva-utils 


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


# Set the shell to case-insensitive
echo "bind \"set completion-ignore-case on\"" >> ~/.bashrc


# Create directories and set default directory to ~/Documents for new terminal sessions
mkdir -p ~/Downloads ~/Documents
echo "cd ~/Documents" >> ~/.bashrc



###### setup acpid functionality ##########
sudo cp acpid_configs/powerbtn /etc/acpi/events/
sudo cp acpid_configs/lid /etc/acpi/events/
sudo cp acpid_configs/lock_and_action.sh /usr/local/bin/
sudo cp acpid_configs/lock.sh /usr/local/bin/

# Add polkit rule to allow suspend and hibernate without sudo
echo "polkit.addRule(function(action, subject) {
    if (action.id == \"org.freedesktop.login1.suspend\" ||
        action.id == \"org.freedesktop.login1.suspend-multiple-sessions\" ||
        action.id == \"org.freedesktop.login1.hibernate\" ||
        action.id == \"org.freedesktop.login1.hibernate-multiple-sessions\") {
        return polkit.Result.YES;
    }
});" | sudo tee -a /etc/polkit-1/rules.d/50-allow-suspend.rules > /dev/null

# Enable acpid and polkit services
sudo systemctl enable acpid
sudo systemctl enable polkit
###########################################


read -p "Vuoi installare Flutter? [y/N] " install_flutter
if [[ "$install_flutter" =~ ^[Yy]$ ]]; then
    ./install_flutter.sh
fi


read -p "Vuoi installare LaTeX? [y/N] " install_latex
if [[ "$install_latex" =~ ^[Yy]$ ]]; then
    yay -S --rebuildall --rebuildtree --noconfirm texlive-full
fi


echo "Installazione completata."
echo "Imposta il tema con lxappearance"
echo "Riavvia il sistema per applicare le modifiche."
