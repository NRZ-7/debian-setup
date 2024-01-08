#!/bin/bash

#Install xfce4
apt-get install -y xfce4 xfce4-goodies lightdm

#Stop xfce4-panel using $userName user
sudo -u $userName pkill -SIGTERM -f xfce4-panel
#Remove current configuration files
rm -r /home/$userName/.config/xfce4
#sleep 0.2
#Copy custom config to xfce4 username config path
cp -r $current_dir/config.d/xfce4 /home/$userName/.config/xfce4
#sleep 0.5
#Setting permissions from root to $userName
chown -R $userName:$userName /home/$userName/.config/xfce4

#Start xfce4-panel on $userName session
#sudo -u $userName xfce4-panel

reboot_system=true