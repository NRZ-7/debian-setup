#!/bin/bash

##################
##  PARAMETERS  ##
##################

userName=changeMe                   # Needs to match with your Debian user name.
sudo_install=false                  # Install and configure sudo for your Debian user name
bash_completion_install=false       # Install and configure bash-completion for root user
openssh_server_install=false        # Install and configure openssh-server
disable_ssh_users=false             # Disable ssh login for all users EXCEPT $userName
virtualbox_guest_additions=false    #Install and configure oficial fasttrack repositories and install virtualbox-guest-x11

#apache2_install=false
#vfptd_install=false
#mariaDB_install=false

#List of utilities to install without any extra config
utilities_to_install="vim htop tree" 


                                        ##############
#---------------------------------------##  SCRIPT  ##--------------------------------------#
                                        ##############


#define current script directory
current_dir=$(dirname "$0")
src_dir=$current_dir"/src"
config_dir=$current_dir"/config.d"

# Define output colors
cyan='\033[0;36m'
green='\033[0;32m'
yellow='\033[0;33m' 
red='\033[1;31m'
colorOff='\033[0m'

# Function to execute scripts
scriptExec() {
    # Define variables
    scriptName="$1" # $1 is a variable taken when scriptExec is called (e.g., scriptExec sudo)
    # Define the path including the script name
    scriptPath="$src_dir/$scriptName.sh"

    echo -e $cyan"\n Installing $scriptName...\n"$colorOff

    # check if scriptPath exists
    if [ -f $scriptPath ]; then
        # If it exists, call the script
        source $scriptPath
    else
        # If not, show an error
        echo -e $red" ERROR: $scriptPath not found"$colorOff
    fi
}

# Function to install a package based on the specified conditions
install_pkg() {
    local do_it=$1 # Take the first argument and store it in the local variable do_it
    local pkg=$2 # Take the second argument and store it in the local variable pkg
    if ( $do_it = true ) ; then
        scriptExec $pkg
    else
        echo -e $cyan"\n $pkg installation disabled in config"$colorOff
    fi
}

####################################
## SOME CHECKS TO PREVENT ERRORS  ##
####################################

# Check if shell is Bourne Agains Shell (BASH)
if [ -z "$BASH_VERSION" ]; then
    echo -e $red" ERROR: This script is designed to be executed with Bash. Try running $yellow./script.sh$red or$yellow bash script.sh"$colorOff
    exit 1
fi

# Check if userName exists
echo -e "$cyan \n Checking if $yellow$userName$cyan user exists\n "$colorOff

if [ $(cat /etc/passwd | grep -c '^'$userName':') = 1 ]; then
    echo -e $green" User exists... Nice!"$colorOff
else   
    echo -e $red" ERROR: User does not exist... Please edit script.sh file and check the firsts parameters. Exiting..."$colorOff
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
apt-get update -y

# Upgrade installed packages
echo -e $cyan "\n Upgrading packages... \n"$colorOff
apt-get upgrade -y


##############################################
##  INSTALL AND SET UP CONFIGURED PACKAGES  ##
##############################################

install_pkg "$bash_completion_install" "bash-completion"

install_pkg "$sudo_install" "sudo" 

install_pkg "$openssh_server_install" "openssh-server"

install_pkg "$virtualbox_guest_additions" "vbox-guest-additions"

################################################
## INSTALL UTILITIES WITHOUT ANY EXTRA CONFIG ##
################################################

apt install $utilities_to_install -y

# Clean unnecessary packages
echo -e $cyan"\n Cleaning unnecessary packages... \n"$colorOff
apt-get autoremove -y