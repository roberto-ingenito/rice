#!/bin/bash


# set pacman to install packages in parallel
sudo sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 10/' /etc/pacman.conf


# Update system
sudo pacman -Syu


# Install essential packages 
sudo pacman -S --needed --noconfirm \
    base-devel cmake ninja meson \
    git github-cli \
    wget \
    nodejs npm \
    discord \
    spotify-launcher \
    curl git unzip xz zip


#####################
#### Install YAY ####
#####################
if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
else
    echo "yay è già installato, proseguo con il resto dell'installazione..."
fi
#####################
#### Install YAY ####
#####################


############################
#### Install GPU driver ####
############################
echo "Seleziona il produttore della tua GPU:"
echo "1) NVIDIA"
echo "2) AMD"
read -p "Inserisci il numero corrispondente (1/2): " choice

if [[ "$choice" == "1" ]]; then
    echo "Hai scelto NVIDIA. Installazione dei driver..."
    sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
elif [[ "$choice" == "2" ]]; then
    echo "Hai scelto AMD. Installazione dei driver..."
    sudo pacman -S --noconfirm \
        mesa \
        lib32-mesa \
        vulkan-radeon \
        lib32-vulkan-radeon \
        libva-mesa-driver \
        libva-utils 
else
    echo "Scelta non valida. Nessuna azione eseguita."
fi
############################
#### Install GPU driver ####
############################


# Install AUR packages
yay -S --needed --rebuildall --rebuildtree --noconfirm \
    visual-studio-code-bin \
    google-chrome \
    freeoffice \
    zapzap \
    plasma6-applets-panel-colorizer \
    kwin-effect-rounded-corners-git
    

# Set git user
git config --global user.email "ingenitoroby@gmail.com"
git config --global user.name "Roberto Ingenito"


############################
#### Install KDE Plasma ####
############################

# tool per rimuovere l'ombra dai panel
sudo pacman -S --needed --noconfirm xorg-xprop xdotool 
mkdir -p ~/.config/autostart
cp remove_panels_shadow.sh ~/.config/autostart
echo -e "[Desktop Entry]
Exec=$HOME/.config/autostart/remove_panels_shadow.sh
Icon=application-x-shellscript
Name=remove_panels_shadow.sh
Type=Application
X-KDE-AutostartScript=true" > ~/.config/autostart/script.sh.desktop

echo -e "[Greeter][Wallpaper][org.kde.image][General]
Image=$HOME/.local/share/wallpapers/wallpaper.jpg
PreviewImage=$HOME/.local/share/wallpapers/wallpaper.jpg" > ~/.config/kscreenlockerrc

# Install dotfiles
cp -rf configs/* ~/.config/

############################
#### Install KDE Plasma ####
############################


#########################
#### Install Flutter ####
#########################
read -p "Vuoi installare Flutter? [y/N] " install_flutter
if [[ "$install_flutter" =~ ^[Yy]$ ]]; then
    pushd ~/.local/share
    git clone -b stable https://github.com/flutter/flutter.git
    ./flutter/bin/flutter --version
    popd

    echo 'export PATH="$PATH:$HOME/.local/share/flutter/bin"' >> ~/.bashrc
    echo 'export PATH="$PATH:$HOME/.local/share/flutter/bin"' >> ~/.zshenv

    echo "export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable" >> ~/.bashrc
    echo "export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable" >> ~/.zshenv

    yay -Sy --rebuildall --rebuildtree --noconfirm \
        android-sdk \
        android-sdk-platform-tools \
        android-sdk-build-tools \
        android-sdk-cmdline-tools-latest \
        android-platform

    echo 'export ANDROID_HOME="/opt/android-sdk"' >> ~/.bashrc
    echo 'export ANDROID_HOME="/opt/android-sdk"' >> ~/.zshenv
    
    echo 'export PATH="$PATH:$ANDROID_HOME/platform-tools"' >> ~/.bashrc
    echo 'export PATH="$PATH:$ANDROID_HOME/platform-tools"' >> ~/.zshenv

    sudo chown -R $USER /opt/android-sdk

    source ~/.bashrc
    source ~/.zshenv

    # installa ed imposta l'ultima versione di java
    sudo pacman -S --needed --noconfirm jdk17-openjdk
    sudo archlinux-java set java-17-openjdk

    # accetta tutte le licenze di android
    yes | flutter doctor --android-licenses
fi
#########################
#### Install Flutter ####
#########################


#######################
#### Install LaTeX ####
#######################
read -p "Vuoi installare LaTeX? [y/N] " install_latex
if [[ "$install_latex" =~ ^[Yy]$ ]]; then
    sudo pacman -S --needed --noconfirm \
        texlive-basic \
        texlive-bibtexextra \
        texlive-langenglish \
        texlive-langitalian \
        texlive-latex \
        texlive-latexextra \
        texlive-latexrecommended \
        texlive-mathscience \
        texlive-pictures \
        texlive-binextra \
        perl-yaml-tiny perl-file-homedir
fi
#######################
#### Install LaTeX ####
#######################


# Remove timeout from bootloader
sudo sed -i 's/^timeout.*/timeout 0/' /boot/loader/loader.conf


# wallpaper
mkdir -p ~/.local/share/wallpapers/
cp -f wallpaper.jpg ~/.local/share/wallpapers/


# Install spotify crack
spotify-launcher --no-exec
bash <(curl -sSL https://spotx-official.github.io/run.sh)


echo "Installazione completata."
echo "  - Imposta il teema Breeze-Dark"
echo "  - Installa ed imposta il set di icone \"Papirus-Dark\""
echo "Riavvia per applicare le modifiche."
