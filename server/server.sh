# gets the username from the user for /home/username
echo "Please input your username:"
read MAINUSER
echo "$MAINUSER"

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


echo -ne "

----------------------------------------------------------------------

                            Enabling SSH

----------------------------------------------------------------------

"

# function to enable ssh on this machine
setup_ssh() {
    sudo pacman -S openssh --noconfirm --needed
    sudo systemctl start sshd
    sudo systemctl enable sshd
    echo "SSH enabled, use the command 'ip a' to find your ip address"

}
if [ $AUTO == true ]
then
    setup_ssh
else
    read -p "Do you want to Enable SSH? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        setup_ssh
    fi
fi

echo -ne "

----------------------------------------------------------------------

                            Installing Surfshark

----------------------------------------------------------------------

"

# function to enable surfshark vpn on this machine
setup_surfshark() {
    pamac build surfshark-vpn --noconfirm --needed # surfshark vpn

}
if [ $AUTO == true ]
then
    setup_surfshark
else
    read -p "Do you want to Install Surfshark VPN? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        setup_surfshark
    fi
fi

echo -ne "

----------------------------------------------------------------------

                            Installing Deluge

----------------------------------------------------------------------

"

# function to install deluge
setup_deluge() {
    sudo pacman -S deluge --noconfirm --needed
    echo "Installing Deluge"
    echo "Making Directories for Deluge"
    # creates directories
    sudo mkdir "/home/$MAINUSER/Torrents/"
    sudo mkdir "/home/$MAINUSER/Torrents/downloading/"
    sudo mkdir "/home/$MAINUSER/Torrents/backups/"
    sudo mkdir "/home/$MAINUSER/Torrents/watch/"
    sudo chown -R $MAINUSER:$MAINUSER "/home/$MAINUSER/Torrents/" # sets permissions to Torrents folder

}
if [ $AUTO == true ]
then
    setup_deluge
else
    read -p "Do you want to Install Deluge? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        setup_deluge
    fi
fi

echo -ne "

----------------------------------------------------------------------

                            Enabling Startup Script

----------------------------------------------------------------------

"

# function to run startup.sh on boot
setup_startup() {
    sudo cp "$CWD/startup.sh" "/usr/local/sbin/" # copies startup.sh to directory
    sudo chmod +x "/usr/local/sbin/startup.sh"
    sudo cp "$CWD/startup.service" "/etc/systemd/system/"
    sudo systemctl enable startup.service

}
if [ $AUTO == true ]
then
    setup_startup
else
    read -p "Do you want to Create a Startup Script that runs startup.sh on boot? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        setup_startup
    fi
fi