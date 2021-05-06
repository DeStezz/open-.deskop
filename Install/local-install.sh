#!/bin/bash
cd `dirname $0`
echo "Copying script to ~/.local/bin"
mkdir ~/.local/bin/ 2> /dev/null
cp ../desktop-file-open.sh ~/.local/bin/desktop-file-open
echo "Copying desktop file tp ~/.local/share/applications"
cp ./Files/Local-install/desktop-file-open.desktop ~/.local/share/applications/.desktop-file-open.desktop
sed -i "s%\$home%$HOME%g" ~/.local/share/applications/.desktop-file-open.desktop #replace $home with the home directory in the .desktop file
echo "Changing permssions"
chmod +x ~/.local/bin/desktop-file-open ~/.local/share/applications/.desktop-file-open.desktop
echo
echo "NOTE: you may need to add \`export PATH=\"\$HOME/.local/bin:\$PATH\"\` to your bashrc file if you want to be able to run from command line."
echo
echo Done.
