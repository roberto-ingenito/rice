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
    nodejs npm


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
    

# Set git user
git config --global user.email "ingenitoroby@gmail.com"
git config --global user.name "Roberto Ingenito"


# Install dotfiles
cp -rf configs/* ~/.config/


read -p "Vuoi installare Flutter? [y/N] " install_flutter
if [[ "$install_flutter" =~ ^[Yy]$ ]]; then
    sudo pacman -S --needed --noconfirm curl git unzip xz zip

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
    sudo pacman -S --needed --noconfirm jdk-openjdk
    LATEST_JAVA=$(ls -d /usr/lib/jvm/*-openjdk | sort -V | tail -n 1)
    sudo archlinux-java set $(basename $LATEST_JAVA)

    # accetta tutte le licenze di android
    yes | flutter doctor --android-licenses
fi


read -p "Vuoi installare LaTeX? [y/N] " install_latex
if [[ "$install_latex" =~ ^[Yy]$ ]]; then
    yay -S --rebuildall --rebuildtree --noconfirm texlive-full
fi


echo "Installazione completata."
echo "Imposta la foto di sfondo."
echo "Riavvia il sistema per applicare le modifiche."
