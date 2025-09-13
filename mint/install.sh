######################
#### install snap ####
######################
sudo rm /etc/apt/preferences.d/nosnap.pref
sudo apt update && sudo apt upgrade
sudo apt install snapd

########################
#### install chrome ####
########################
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb


sudo snap install code --classic
sudo snap install brave
sudo snap install android-studio --classic
 
sudo apt-get install --no-install-recommends \
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

sudo apt install git
sudo apt install nodejs npm

# Set git user
git config --global user.email "ingenitoroby@gmail.com"
git config --global user.name "Roberto Ingenito"


############################
#### install github cli ####
############################
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y


######################
#### install .NET ####
######################
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x ./dotnet-install.sh
sudo ./dotnet-install.sh --channel 9.0 --install-dir "/usr/share/dotnet"
rm ./dotnet-install.sh

# Verifica se /usr/share/dotnet è già presente in PATH.
# Se non c'è, lo aggiunge alla fine della riga PATH=... 
grep -q '/usr/share/dotnet' /etc/environment || sudo sed -i '/^PATH=/ s|"$|:/usr/share/dotnet"|' /etc/environment


#######################
#### install cider ####
#######################
sudo snap install curl
curl -fsSL https://repo.cider.sh/APT-GPG-KEY | sudo gpg --dearmor -o /usr/share/keyrings/cider-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/cider-archive-keyring.gpg] https://repo.cider.sh/apt stable main" | sudo tee /etc/apt/sources.list.d/cider.list
sudo apt update
sudo apt install cider







