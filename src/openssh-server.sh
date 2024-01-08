#!/bin/bash

    # Install ssh
    apt-get install -y openssh-server

    #Define sshd_config file path
    sshd_configFile="/etc/ssh/sshd_config.d/sshd_config"

    # copying config file
    cp $config_dir/sshd_config $sshd_configFile
    echo -e $cyan"\n Copying $config_dir/sshd_config to $sshd_configFile"$colorOff


    #Disable ssh login for all users EXCEPT $userName
    if [ $disable_ssh_users == true ]; then

        echo "" >> $sshd_configFile
        echo "# Allow only users from this list" >> $sshd_configFile
        echo -e "AllowUsers $userName" >> $sshd_configFile

        echo -e $green"\n DONE: Disable ssh login for all users EXCEPT $userName"$colorOff

    else
        echo -e $yellow"\n Skipping: Disable ssh login for all users EXCEPT $userName is DISABLED in config"$colorOff
    fi
