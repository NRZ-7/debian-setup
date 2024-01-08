#!/bin/bash
# DOCUMENTATION: https://vscodium.com/

#Add the GPG key of the repository:
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

#Add the repository:
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list

#Update then install vscodium (if you want vscodium-insiders, then replace codium by codium-insiders):
sudo apt-get update && sudo apt-get install -y codium

# Check if "codium" package is installed.
if dpkg -l | grep -q codium; then
    echo -e $green"\n VSCodium is installed and repository added"$colorOff
else
    echo -e $red" WARNING: VSCodium failed to install"$colorOff >&2
fi
