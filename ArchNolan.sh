#!/usr/bin/env bash
# Shell script to install a lot of packages I use for Arch Linux
# Inspired by ArchTitus https://github.com/ChrisTitusTech/ArchTitus
# Script is to be used after running the ArchTitus script on a fresh Arch Linux Install 

# TODO make script install snap if not present
# TODO downgrade yay Package

PKGS_PACMAN=(
'discord'
'telegram-desktop'
'networkmanager-openvpn'
'firefox'
'vlc'
'flatpak'
)

PKGS_SNAP=(
'slack'
'qbittorrent-arnatious'
'retroarch'
'gitkraken --classic' # TODO not working
)

PKGS_PYTHON=(
'numpy'
'matplotlib'
'wikipedia-api'
'discord.py'
'install google-api-python-client'
'imdbpy'
)

PKGS_VSCODE=(
'vscodevim.vim'
'ritwickdey.liveserver'
)

# installs pacman packages
echo 'Installing pacman packages'
for PKG in "${PKGS_PACMAN[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

# installs snap packages
echo 'Installing snap packages'
for PKG in "${PKGS_SNAP[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo snap install "$PKG"
done

echo 'installing Python modules'
pip install -r python_modules.txt

# installs VsCode extensions
echo 'Installing Python Modules'
for PKG in "${PKGS_VSCODE[@]}"; do
    echo "INSTALLING: ${PKG}"
    code --install-extension ${PKG}
done

# Installs the newest GloriousEggroll Proton file and places it in the Steam compatability directory
echo 'Installing GloriousEggroll Proton to Steam directory'
curl -IkLs -o NUL -w %{url_effective} https://github.com/GloriousEggroll/proton-ge-custom/releases/latest \
     | grep -o "[^/]*$"\
     | xargs -I T \
       curl -kL https://github.com/GloriousEggroll/proton-ge-custom/releases/download/T/Proton-T.tar.gz \
       -o temp.tar.gz
tar xf temp.tar.gz
sudo rm temp.tar.gz
sudo rm NUL

sudo mkdir "/home/nolan/.steam/root/compatibilitytools.d"
for f in */ ; do 
    mv "$f" "/home/nolan/.steam/root/compatibilitytools.d";
    sudo rm -r "$f"; # used for if the folder is already in compatabilitytools.d
done

# TODO
# install Bulk Rename Utility
#