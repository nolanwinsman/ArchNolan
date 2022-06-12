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
    pamac build surfshark-vpn # surfshark vpn

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
