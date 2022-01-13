#!/usr/bin/env bash
# Shell script to install a lot of packages I use for Arch Linux
# Inspired by ArchTitus https://github.com/ChrisTitusTech/ArchTitus
# Script is to be used after running the ArchTitus script on a fresh Arch Linux Install 

# TODO make script install snap if not present

# gets the username from the user for /home/username
echo "Please input your username:"
read MAINUSER
echo "$MAINUSER"

# checks if the directory exists
if [ -d "/home/$MAINUSER/" ]
then
    HOMEDIR="/home/$MAINUSER/"
    echo "$HOMEDIR exists, continuing with program"
else
    # directory does not exist so the code is exited
    echo "/home/$MAINUSER/ does not exist, exiting code"
    exit 404
fi

PKGS_PACMAN=(
'discord'
'telegram-desktop'
'networkmanager-openvpn'
'firefox'
'vlc'
'flatpak'
'tk'
'netcat'
'nmap'
'flameshot'
'ruby'
'npx'
'nodejs'
'code'
'gimp'
'wine-gecko'
'wine-mono'
'winetricks'
'vim'
'steam'
'wget'
'kitty'
'gcc'
'git'
'mcomix'
'lm_sensors'
'virt-manager qemu vde2 ebtables dnsmasq bridge-utils openbsd-netcat' # virtual machine dependencies
)

PKGS_SNAP=(
'slack --classic' # TODO not working
'qbittorrent-arnatious'
'retroarch'
'gitkraken --classic' # TODO not working
'obs-studio'
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
'dsznajder.es7-react-js-snippets'
)

echo -ne "

-------------------------------------------------------------------------

                            Pacman Pakages

-------------------------------------------------------------------------

" # installs pacman packages
for PKG in "${PKGS_PACMAN[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

echo -ne "

-------------------------------------------------------------------------

                            Snap Pakages

-------------------------------------------------------------------------

" # installs snap packages
sudo ln -s /var/lib/snapd/snap /snap # makes a symbolic link

for PKG in "${PKGS_SNAP[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo snap install "$PKG"
done

echo -ne "

-------------------------------------------------------------------------

                            Python Modules

-------------------------------------------------------------------------

" # installs python pip modules
pip install -r python_modules.txt

# installs VsCode extensions
echo -ne "

-------------------------------------------------------------------------

                            VS Code Extensions

-------------------------------------------------------------------------

" # installs vs code extensions
for PKG in "${PKGS_VSCODE[@]}"; do
    echo "INSTALLING: ${PKG}"
    code --install-extension ${PKG}
done

# Graphics Drivers find and install
echo -ne "

-------------------------------------------------------------------------

                            Graphics Drivers

-------------------------------------------------------------------------

" # code taken from ArchTitus, used for installing graphics drivers
gpu_type=$(lspci)
if grep -E "NVIDIA|GeForce" <<< ${gpu_type}; then
    pacman -S nvidia --noconfirm --needed
	nvidia-xconfig
elif lspci | grep 'VGA' | grep -E "Radeon|AMD"; then
    pacman -S xf86-video-amdgpu --noconfirm --needed
elif grep -E "Integrated Graphics Controller" <<< ${gpu_type}; then
    pacman -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils lib32-mesa --needed --noconfirm
elif grep -E "Intel Corporation UHD" <<< ${gpu_type}; then
    pacman -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils lib32-mesa --needed --noconfirm
fi

echo -ne "

-------------------------------------------------------------------------

                            Kitty Terminal Setup

-------------------------------------------------------------------------

" # applies kitty config file and adds opaque theme to Kitty
KITTY="$HOMEDIR.config/kitty"

cp "kitty/kitty.conf" "$KITTY"
sudo mkdir "$KITTY/themes/" # makes themes directory if it does not already exist
cp "kitty/opaque.conf" "$KITTY/themes"

echo -ne "

-------------------------------------------------------------------------

                            Bulk Rename Utility

-------------------------------------------------------------------------

# " # Downloads Bulk Rename Utility and installs it using wine
# wget https://www.bulkrenameutility.co.uk/Downloads/BRU_setup.exe
# wine BRU_setup.exe # installs Bulk Rename Utility using WINE
# sudo rm BRU_setup.exe

# # Installs the newest GloriousEggroll Proton file and places it in the Steam compatability directory
echo -ne "

-------------------------------------------------------------------------

                            Proton-GE

-------------------------------------------------------------------------

" # installs the newest version of Proton-GE and installs it to the compatabilitytools.d directory in steam
curl -IkLs -o NUL -w %{url_effective} https://github.com/GloriousEggroll/proton-ge-custom/releases/latest \
     | grep -o "[^/]*$"\
     | xargs -I T \
       curl -kL https://github.com/GloriousEggroll/proton-ge-custom/releases/download/T/Proton-T.tar.gz \
       -o temp.tar.gz
tar xf temp.tar.gz
sudo rm temp.tar.gz
sudo rm NUL

sudo mkdir "/home/nolan/.steam/root/compatibilitytools.d"

for file in *"Proton"* ; do
    echo "Moving $file to $HOMEDIR.steam/root/compatabilitytools.d"
    echo "If file is already there, deletes the file here"
    mv "$file" "$HOMEDIR.steam/root/compatibilitytools.d";
    echo "Deleting file $file"
    sudo rm -r "$file"; # used for if the folder is already in compatabilitytools.d
done