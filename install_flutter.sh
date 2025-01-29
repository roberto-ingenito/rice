#!/bin/bash

yay -S --rebuildall --rebuildtree --noconfirm \
    flutter \
    dart \
    android-tools \
    android-sdk \
    android-sdk-platform-tools \
    android-sdk-build-tools

sudo pacman -S jdk-openjdk

# Add Google Chrome executable to the /etc/environment file (needed for Flutter web development)
echo "CHROME_EXECUTABLE=/usr/bin/google-chrome-stable" | sudo tee -a /etc/environment > /dev/null
