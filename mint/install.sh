#!/bin/bash

# Interrompe l'esecuzione se un comando fallisce
set -e

# Funzioni per colorare l'output
info() {
    echo -e "\n\033[1;34m[INFO]\033[0m $1"
}

success() {
    echo -e "\033[1;32m[SUCCESSO]\033[0m $1"
}

# Funzione per chiedere all'utente se vuole procedere
# Ritorna 0 (true) se l'utente digita 'y' o 'Y', 1 (false) altrimenti.
ask_to_install() {
    read -p $'\n\033[1;33m[DOMANDA]\033[0m Vuoi installare '"$1"'? (y/n) ' -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}


#################################
#### DEFINIZIONE FUNZIONI    ####
#################################

install_snapd() {
    info "Abilitazione e installazione di Snapd..."
    sudo rm -f /etc/apt/preferences.d/nosnap.pref
    sudo apt update
    sudo apt install -y snapd
    success "Snapd installato."
}

install_chrome() {
    info "Installazione di Google Chrome..."
    wget -q --show-progress https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome-stable_current_amd64.deb
    sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
    # Risolve eventuali dipendenze mancanti
    sudo apt-get install -f -y
    rm /tmp/google-chrome-stable_current_amd64.deb
    success "Google Chrome installato."
}

install_snap_apps() {
    if ask_to_install "Visual Studio Code"; then
        info "Installazione di Visual Studio Code..."
        sudo snap install code --classic
        success "Visual Studio Code installato."
    fi
    if ask_to_install "Brave Browser"; then
        info "Installazione di Brave Browser..."
        sudo snap install brave
        success "Brave Browser installato."
    fi
    if ask_to_install "Android Studio"; then
        info "Installazione di Android Studio..."
        sudo snap install android-studio --classic
        success "Android Studio installato."
    fi
}

install_latex() {
    info "Installazione di TeX Live (LaTeX)..."
    sudo apt-get install -y --no-install-recommends \
        texlive-base \
        texlive-bibtex-extra \
        texlive-lang-english \
        texlive-lang-italian \
        texlive-latex-base \
        texlive-latex-extra \
        texlive-latex-recommended \
        texlive-science \
        texlive-pictures \
        texlive-binaries \
        libyaml-tiny-perl libfile-homedir-perl
    success "TeX Live installato."
}

install_dev_tools() {
    info "Installazione di Git, Node.js e npm..."
    sudo apt install -y git nodejs npm
    success "Strumenti di sviluppo installati."
    
    # Chiede se configurare Git solo se è stato installato
    if ask_to_install "configurare Git globalmente"; then
        read -p "Inserisci il tuo nome per Git: " git_name
        read -p "Inserisci la tua email per Git: " git_email
        git config --global user.name "$git_name"
        git config --global user.email "$git_email"
        success "Git configurato con nome '$git_name' e email '$git_email'."
    fi
}

install_github_cli() {
    info "Installazione di GitHub CLI..."
    (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
    && sudo mkdir -p -m 755 /etc/apt/keyrings \
    && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install -y gh
    success "GitHub CLI installato."
}

install_dotnet() {
    info "Installazione di .NET SDK..."
    wget https://dot.net/v1/dotnet-install.sh -O /tmp/dotnet-install.sh
    chmod +x /tmp/dotnet-install.sh
    sudo /tmp/dotnet-install.sh --channel 9.0 --install-dir "/usr/share/dotnet"
    rm /tmp/dotnet-install.sh

    # Aggiunge dotnet al PATH di sistema se non è già presente
    if ! grep -q '/usr/share/dotnet' /etc/environment; then
        sudo sed -i '/^PATH=/ s|"$|:/usr/share/dotnet"|' /etc/environment
        success ".NET SDK installato e aggiunto al PATH. Riavvia il terminale per applicare le modifiche."
    else
        success ".NET SDK installato (il PATH era già configurato)."
    fi
}

install_cider() {
    info "Installazione di Cider..."
    sudo apt install -y curl
    curl -fsSL https://repo.cider.sh/APT-GPG-KEY | sudo gpg --dearmor -o /usr/share/keyrings/cider-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/cider-archive-keyring.gpg] https://repo.cider.sh/apt stable main" | sudo tee /etc/apt/sources.list.d/cider.list
    sudo apt update
    sudo apt install -y cider
    success "Cider installato."
}

install_docker() {
    info "Installazione di Docker..."
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    success "Docker installato."
}


#################################
#### ESECUZIONE DELLO SCRIPT ####
#################################

info "Inizio dello script di installazione personalizzata."

sudo apt update && sudo apt upgrade -y

if ask_to_install "Snapd (necessario per VSCode, Brave, etc.)"; then
    install_snapd
fi

if ask_to_install "Google Chrome"; then
    install_chrome
fi

# Chiede di installare le app Snap solo se Snapd è installato o l'utente ha scelto di installarlo
if command -v snap &> /dev/null; then
    install_snap_apps
fi

if ask_to_install "LaTeX (TeX Live)"; then
    install_latex
fi

if ask_to_install "Strumenti di sviluppo (Git, Node.js, npm)"; then
    install_dev_tools
fi

if ask_to_install "GitHub CLI"; then
    install_github_cli
fi

if ask_to_install ".NET 9 SDK"; then
    install_dotnet
fi

if ask_to_install "Cider"; then
    install_cider
fi

if ask_to_install "Docker"; then
    install_docker
fi

success "Script completato! Tutti i pacchetti selezionati sono stati installati."
