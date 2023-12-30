#Stop xfce4-panel using $userName user
su $userName -c 'xfce4-panel --quit'
#Remove current dir
rm -r /home/$userName/.config/xfce4
#Copy setup to config path
cp -r $current_dir/config.d/xfce4 /home/$userName/.config/xfce4
#Setting permissions from root to $userName
chown -R $userName:$userName /home/$userName/.config/xfce4*
#Start xfce4-panel on $userName session
su $userName -c 'xfce4-panel'
