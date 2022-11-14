#!/bin/bash
# Shell script to install a lot of packages I use for Arch Linux
# Inspired by ArchTitus https://github.com/ChrisTitusTech/ArchTitus
# Script is to be used after running the ArchTitus script on a fresh Arch Linux Install 

# TODO make script install snap if not present
# TODO npm install -g expo-cli

# gets the username from the user for /home/username
echo "Please input your username:"
read MAINUSER
echo "$MAINUSER"

# if the first argument is "-y" then everything is installed and configured.
if [[ "$1" == "-y" ]]; then
        echo "Auto accepting every setup"
        AUTO=true
else
        echo "Not automatically accepting every setup. Use -y as the first argument to automatically say yes to everything\n"
        AUTO=false
fi

# checks if the directory exists
if [ -d "/home/$MAINUSER/" ]
then
    HOMEDIR="/home/$MAINUSER"
    echo "$HOMEDIR exists, continuing with program"
else
    # directory does not exist so the code is exited
    echo "/home/$MAINUSER/ does not exist, exiting code"
    exit 404
fi

CWD=$(pwd) # sets the current working directory to a variable

# TODO
# yay packages
# picom-git
# yay -S balena-etcher
# yay -S goverlay (Github One)

# paru
# libreoffice-extension-languagetool
# hsqldb2-java
# ttf-gentium-basic

# TODO rvm the ruby package manager

PKGS_PACMAN=(
'discord'
'networkmanager-openvpn'
'firefox'
'vlc'
'flatpak'
'tk'
'netcat'
'nmap'
'flameshot' # screenshot utility
'gimp'
'wine-gecko'
'wine-mono'
'winetricks'
'steam'
'wget'
'kitty'
'git'
'mcomix'
'lm_sensors'
'bless'
'qemu python python-pip python-wheel' # Mac VM dependencies
'lutris'
'locate'
'scrcpy' # Control Android over USB
'sqlitebrowser'
'base-devel --needed'
'--needed jre-openjdk'
'libreoffice-still'
'hunspell'
'hunspell-en_us'
'dolphin-emu'
'tree'
'brave-browser'
'etcher'
# Programming Languages
'julia'
'gcc' # C compiler
'nodejs npm'
'ruby'
'neovim'
'nodejs'
'npx'
'code' # VS Code
)

PKGS_YAY={
    'github-desktop'

}

PKGS_SNAP=(
"slack --classic" # TODO not working
'qbittorrent-arnatious'
'retroarch'
"gitkraken --classic" # TODO not working
'obs-studio'
'spotify'
)

PKGS_PYTHON=(
'numpy'
'matplotlib'
'wikipedia-api'
'discord.py'
'install google-api-python-client'
'imdbpy'
)

# TODO these are not working
PKGS_VSCODE=(
'vscodevim.vim'
'ritwickdey.liveserver'
'dsznajder.es7-react-js-snippets'
)
echo -ne "

----------------------------------------------------------------------

                            Pacman Pakages

----------------------------------------------------------------------

" # installs pacman packages

# function to install all pacman packages
pacman_packages() {
    for PKG in "${PKGS_PACMAN[@]}"; do
        echo "INSTALLING: ${PKG}"
        sudo pacman -S "$PKG" --noconfirm --needed
    done
    pamac install yay && yay -S surfshark-vpn # surfshark vpn
    sudo pacman -S --needed ttf-caladea ttf-carlito ttf-dejavu ttf-liberation ttf-linux-libertine-g noto-fonts adobe-source-code-pro-fonts adobe-source-sans-pro-fonts adobe-source-serif-pro-fonts

}
if [ $AUTO == true ]
then
    pacman_packages
else
    read -p "Do you want to install Pacman Packages? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        pacman_packages
    fi
fi

echo -ne "

----------------------------------------------------------------------

                            Yay Pakages

----------------------------------------------------------------------

" # installs pacman packages

# function to install all pacman packages
yay_packages() {
    for PKG in "${PKGS_PACMAN[@]}"; do
        echo "INSTALLING: ${PKG}"
        yay -S "$PKG" --noconfirm --needed
    done


}
if [ $AUTO == true ]
then
    yay_packages
else
    read -p "Do you want to install Yay Packages? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        yay_packages
    fi
fi
echo -ne "

----------------------------------------------------------------------

                            Snap Pakages

----------------------------------------------------------------------

"# installs all snap packages

# function to install snap packages
snap_packages() {
    sudo ln -s /var/lib/snapd/snap /snap # makes a symbolic link

    for PKG in "${PKGS_SNAP[@]}"; do
        echo "INSTALLING: ${PKG}"
        sudo snap install "$PKG"
done

}
if [ $AUTO == true ]
then
    snap_packages
else
    read -p "Do you want to install Snap Packages? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        snap_packages
    fi
fi
echo -ne "

----------------------------------------------------------------------

                            Python Modules

----------------------------------------------------------------------

" # installs python pip modules
if [ $AUTO == true ]
then
    pip install -r python_modules.txt
else
    read -p "Do you want to install Python Modules? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        pip install -r python_modules.txt
    fi
fi
echo -ne "

----------------------------------------------------------------------

                            VS Code Extensions

----------------------------------------------------------------------

" # installs VsCode extensions

vs_code_extensions(){
    for PKG in "${PKGS_VSCODE[@]}"; do
        echo "INSTALLING: ${PKG}"
        code --install-extension ${PKG}
    done
}

if [ $AUTO == true ]
then
    vs_code_extensions
else
    read -p "Do you want to install VSCode Packages? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        vs_code_extensions
    fi
fi
echo -ne "

----------------------------------------------------------------------

                            Graphics Drivers

----------------------------------------------------------------------

" # Graphics Drivers find and install
 # code taken from ArchTitus, used for installing graphics drivers
gpu_drivers() {
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
}

if [ $AUTO == true ]
then
    gpu_drivers
else
    read -p "Do you want to install GPU Drivers? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        gpu_drivers
    fi
fi
echo -ne "

----------------------------------------------------------------------

                            Kitty Terminal Setup

----------------------------------------------------------------------

" # applies kitty config file and adds opaque theme to Kitty
kitty_config() {
    KITTY="$HOMEDIR/.config/kitty"

    cp "kitty/kitty.conf" "$KITTY"
    sudo mkdir "$KITTY/themes/" # makes themes directory if it does not already exist
    cp "kitty/opaque.conf" "$KITTY/themes"
}

if [ $AUTO == true ]
then
    kitty_config
else
    read -p "Do you want to apply Kitty Terminal Config? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        kitty_config
    fi
fi
echo -ne "

----------------------------------------------------------------------

                            Bulk Rename Utility

----------------------------------------------------------------------

" # Downloads Bulk Rename Utility and installs it using wine
bulk_rename() {
    wget https://www.bulkrenameutility.co.uk/Downloads/BRU_setup.exe # grabs newest version of bulkrename
    wine BRU_setup.exe # installs Bulk Rename Utility using WINE
    sudo rm BRU_setup.exe
}

if [ $AUTO == true ]
then
    bulk_rename
else
    read -p "Do you want to Download and Install Bulk Rename Utility? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        bulk_rename
    fi
fi
echo -ne "

----------------------------------------------------------------------

                            Proton-GE

----------------------------------------------------------------------

" # installs the newest version of Proton-GE and installs it to the compatabilitytools.d directory in steam
proton_setup() {
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
}

if [ $AUTO == true ]
then
    proton_setup
else
    read -p "Do you want to Download and Install Proton-GE " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        proton_setup
    fi
fi
# echo -ne "

# ----------------------------------------------------------------------

#                             Mac Virtual Machine

# ----------------------------------------------------------------------

# " # downloads and installs a Mac Virtual Machine. Some manual configuration is still required

# mac_vm() {
# # checks if the directory exists
# if [ -d "$HOMEDIR/vm/macOS-Simple-KVM" ] # TODO make this check if folder with *mac* exists
#     then
#         echo "Mac VM already setup, to reinstall delete the macOS-Simple-KVM directory"
#     else
#         git clone 'https://github.com/foxlet/macOS-Simple-KVM.git' 
#         mkdir "$HOMEDIR/vm"
#         for file in *"macOS"* ; do
#             cd $file # the way jumpstart.sh runs requires you to be inside the directory
#             echo "Running jumpstart.sh"
#             "./jumpstart.sh"
#             printf "\n\n\n" # prints three new lines to make the output more readable
#             echo "Adding text to basic.sh"
#             basic_line_1='-drive id=SystemDisk,if=none,file=MyDisk.qcow2 \'
#             basic_line_2='-device ide-hd,bus=sata.4,drive=SystemDisk \'
#             printf "    $basic_line_1" >> "basic.sh"
#             printf "\n    $basic_line_2" >> "basic.sh"
#             sudo qemu-img create -f qcow2 MyDisk.qcow2 30G # creates the partition for the Mac VM. Set to 32 Gigabytes
#             cd $CWD
#             echo "Moving $file to $HOMEDIR/vm/"
#             mv $file "$HOMEDIR/vm"
#             rm -r "$file" # for if the file is not moved
#             echo "Changing owners of files"
#             sudo chown "$MAINUSER" "$HOMEDIR/vm" # changes the owner of the directory to the user running the script
#             sudo chown "$MAINUSER" "$HOMEDIR/vm/$file"
#             printf "\n\nMac VM Setup with a disk size of 32 Gigabytes. Delete MyDisk.qcow2 inside $file to delete the partition."
#             printf "To create a new Disk partition for the Mac VM, run the command\n\n"
#             printf "sudo qemu-img create -f qcow2 MyDisk.qcow2 32G \n\n"
#         done
#     fi
# }

# if [ $AUTO == true ]
# then
#     mac_vm
# else
#     read -p "Do you want to Download and a Mac Virtual Machine using qemu " -n 1 -r
#     echo    # (optional) move to a new line
#     if [[ $REPLY =~ ^[Yy]$ ]]
#     then
#         mac_vm
#     fi
# fi

echo -ne "

----------------------------------------------------------------------

                        Node & Expo install

----------------------------------------------------------------------

"
node_setup() {
    sudo n 16.9.0 # I currently need node version 16.9
    sudo npm install --global yarn
    yarn global add expo-cli
    npm install cypress # validate this works
    npm install
}

if [ $AUTO == true ]
then
    node_setup
else
    read -p "Do you want to install and setup Node & Expo? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        node_setup
    fi
fi

echo -ne "

----------------------------------------------------------------------

                        Android Studio

----------------------------------------------------------------------

"
android_studio_setup() {
    git clone https://aur.archlinux.org/android-studio.git
    cd "android-studio"
    makepkg -si
    ANDROID_SDK_ROOT="$HOMEDIR/Android/Sdk/"
    export ANDROID_SDK_ROOT
}
if [ $AUTO == true ]
then
    android_studio_setup
else
    read -p "Do you want to install and setup Android Studio " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        android_studio_setup
    fi
fi



echo -ne "

----------------------------------------------------------------------

                        Peru Setup

----------------------------------------------------------------------

"
peru_setup() {
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    cd "$HOMEDIR"
    sudo rm -r paru
}

if [ $AUTO == true ]
then
    peru_setup
else
    read -p "Do you want to install and setup Peru? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        peru_setup
    fi
fi
#TODO setup alias for MAC to open the vm
#TODO alias mac='cd /home/nolan/vm/macOS-Simple-KVM; sudo ./basic.sh; cd $HOME'
