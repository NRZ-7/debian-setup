#!/bin/bash

#Install xfce4
apt-get install -y xfce4 xfce4-goodies lightdm

#Stop xfce4-panel using $userName user
sudo -u $userName pkill -SIGTERM -f xfce4-panel
#Remove current configuration files
rm -r /home/$userName/.config/xfce4
#Copy custom config to xfce4 username config path
mkdir -p /home/$userName/.config && cp -r $current_dir/config.d/xfce4 /home/$userName/.config/xfce4

#Change user in config files to $userName
#source to undestand command: https://stackoverflow.com/questions/525592/find-and-replace-inside-a-text-file-from-a-bash-command

sed -i -e 's/changeMe/'"$userName"'/g' /home/$userName/.config/xfce4/*


#Setting permissions from root to $userName
chown -R $userName:$userName /home/$userName/.config/xfce4

echo -e $green"\n XFCE is installed and configured"$colorOff

#Start xfce4-panel on $userName session
#sudo -u $userName xfce4-panel

reboot_system=true