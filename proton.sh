echo -ne "

----------------------------------------------------------------------

                            Proton-GE

----------------------------------------------------------------------

" # installs the newest version of Proton-GE and installs it to the compatabilitytools.d directory in steam
curl -IkLs -o NUL -w %{url_effective} https://github.com/GloriousEggroll/proton-ge-custom/releases/latest \
    | grep -o "[^/]*$"\
    | xargs -I T \
    curl -kL https://github.com/GloriousEggroll/proton-ge-custom/releases/download/T/Proton-T.tar.gz \
    -o temp.tar.gz
tar xf temp.tar.gz
sudo rm temp.tar.gz
sudo rm NUL

# sudo mkdir "/home/nolan/.steam/root/compatibilitytools.d"

# for file in *"Proton"* ; do
#     echo "Moving $file to $HOMEDIR.steam/root/compatabilitytools.d"
#     echo "If file is already there, deletes the file here"
#     mv "$file" "$HOMEDIR.steam/root/compatibilitytools.d";
#     echo "Deleting file $file"
#     sudo rm -r "$file"; # used for if the folder is already in compatabilitytools.d
# done