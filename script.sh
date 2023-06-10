#!/bin/bash

##################
##  PARAMETERS  ##
##################

userName=changeMe                    # Needs to match with your Debian user name.
bash_completion_install=true   # Install and configure bash-completion
sudo_install=true              # Install and configure sudo for your Debian user name


                                        ##############
#---------------------------------------##  SCRIPT  ##--------------------------------------#
                                        ##############


#define current script directory
current_dir=$(dirname "$0")
src_dir=$current_dir"/src"

# Define output colors
cyan='\033[0;36m'
green='\033[0;32m'
yellow='\033[0;33m' 
red='\033[1;31m'
colorOff='\033[0m'

scriptExec() {
    scriptName="$1"
    scriptPath="$src_dir/$scriptName.sh"

    echo -e $cyan"\n Installing $scriptName...\n"$colorOff

    #check if scriptPath exists
    if [ -f $scriptPath ]; then
        source $scriptPath
    else
        echo -e $red" ERROR: $scriptPath not found"$colorOff
    fi

}

####################################
## SOME CHECKS TO PREVENT ERRORS  ##
####################################

# Check if userName exists
echo -e "$cyan \n Checking if $yellow$userName$cyan user exists\n "$colorOff

if [ $(cat /etc/passwd | grep -c '^'$userName':') = 1 ]; then
    echo -e $green" User exists... Nice!"$colorOff
else   
    echo -e $red" ERROR: User does not exist... Exiting..."$colorOff
    exit 1
fi

# Check if shell is Bourne Agains Shell (BASH)
if [ -z "$BASH_VERSION" ]; then
echo -e $red" ERROR: This script is designed to be executed with Bash. Try running $yellow./script.sh$red or$yellow bash script.sh"$colorOff
exit 1
fi

# Check distro and exit if is not Debian
# Best compatibility with¿ # cat /etc/os-release | grep '^NAME='
if [ $(lsb_release -is) = 'Debian' ]; then 
    echo -e $green" Your distro seems compatile with this script. The execution will continue..."$colorOff
else
    #If the OS isn't Debian, exit with error message.
    echo -e $red" ERROR: Not supported OS. This script is only for Debian. Exiting..."$colorOff
    exit 1
fi

# Check if the script is being executed as root
if ! [ $(id -u) = 0 ]; then
    echo -e $red" ERROR: This script must be executed as root. Exiting..."$colorOff
    exit 1
fi


##############################
##  UPDATING AND UPGRADING  ##
##############################

# Update package information
echo -e $cyan"\n Updating package information... \n"$colorOff
apt-get update

# Upgrade installed packages
echo -e $cyan "\n Upgrading packages... \n"$colorOff
apt-get upgrade #-y ?


#######################
##  BASH COMPLETION  ##
#######################

# Check bash_completion_install parameter
if [ $bash_completion_install = true ]; then
    
    scriptExec bash-completion

else
    echo -e $cyan"\n bash_completion_install DISABLED in config"$colorOff
fi


############
##  SUDO  ##
############

# Check sudo_install parameter
if [ $sudo_install = true ]; then

    scriptExec sudo

else
    echo -e $cyan"\n sudo_install disabled in config"$colorOff
fi


# Clean unnecessary packages
echo -e $cyan"\n Cleaning unnecessary packages... \n"$colorOff
apt-get autoremove -y