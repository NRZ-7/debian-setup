#Stop xfce4-panel using $userName user
#sudo -u $userName xfce4-panel --quit

#Remove current configuration files
rm -r /home/$userName/.config/xfce4
#Copy custom config to xfce4 username config path
cp -r $current_dir/config.d/xfce4 /home/$userName/.config/xfce4
#Setting permissions from root to $userName
chown -R $userName:$userName /home/$userName/.config/xfce4
#Start xfce4-panel on $userName session
#sudo -u $userName xfce4-panel

reboot_system=true