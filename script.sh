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


# Define output colors
cyan='\033[0;36m'
green='\033[0;32m'
yellow='\033[0;33m' 
red='\033[1;31m'
colorOff='\033[0m'

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
apt-get upgrade


#######################
##  BASH COMPLETION  ##
#######################

# Check bash_completion_install parameter
if [ $bash_completion_install = true ]; then
    # Config bash-compleiton for root user

    echo -e $cyan"\n Install bash-completion\n"$colorOff
    apt-get install bash-completion

    echo -e $cyan"\n Add bash-completion in /root/.bashrc \n"$colorOff

    # Check if bash-completion is called from /root/.bashrc
    if ! grep -q 'if [ -f /etc/bash_completion ]' /root/.bashrc; then

        # Add lines at the end of file /root/.bashrc
        echo "# bash-completion config" >> /root/.bashrc
        echo "if [ -f /etc/bash_completion ]; then" >> /root/.bashrc
        echo "    . /etc/bash_completion" >> /root/.bashrc
        echo "fi" >> /root/.bashrc

        echo -e $green" The configuration of bash-completion has been completed."$colorOff
    else
        echo -e $yellow" The configuration of bash-completion has been skiped as it was already configured for the root user."$colorOff
    fi
else
    echo -e $cyan"\n bash_completion_install disabled in config\n"$colorOff
fi


############
##  SUDO  ##
############

# Check sudo_install parameter
if [ $sudo_install = true ]; then

    echo -e $cyan"\n Install sudo\n"$colorOff
    apt-get install sudo

    # Define sudoers file
    sudoersFile='/etc/sudoers.d/sudoers'

    echo -e $cyan"\n Adding sudo privileges to $userName \n"$colorOff

    # Check if user is in /etc/sudoers
    if ! grep -q $userName /etc/sudoers; then
        # Si no se encuentra el usuario en /etc/sudoers comprueba si existe el fichero sudoers en /etc/sudoers.d/
        if [ -f $sudoersFile ]; then
            # Si el fichero existe, comprueba si existe el usuario
            if ! grep -q $userName $sudoersFile; then
                # Si el fichero existe, pero no el usuario, añade las líneas de código necesarias
                echo '# Users with sudo privileges' >> $sudoersFile
                echo -e "$userName  ALL=(ALL:ALL) ALL" >> $sudoersFile
                echo -e $green "$userName added to $sudoersFile"$colorOff
            else
                # Si el fichero y el usuario ya existen, salta la instalación
                echo -e $yellow" Skipping: $userName is already present in $sudoersFile"$colorOff
            fi
        else
            # Si no existe el fichero /etc/sudoers.d/sudoers ni ninguna referencia al usuario en los archivos sudoers. Crea el archivo y añade el código necesario
            touch $sudoersFile
            echo "" >> $sudoersFile
            echo "# Users with sudo privileges" >> $sudoersFile
            echo -e "$userName     ALL=(ALL:ALL) ALL" >> $sudoersFile
            echo -e $green" $userName added to $sudoersFile"$colorOff
        fi
    else
        # Encuentra el usuario configurado en /etc/sudoers. Avisa de que és una mala práctica y sugiere configurarlo en el directorio sudoers.d
        echo -e $red" WARNING: $userName is alredy present to /etc/sudoers. This works but is a bad practice and can broke your updates. Instead you can add your user to /etc/sudoers.d/ directory"$colorOff
    fi
else
    echo -e $cyan"\n sudo_install disabled in config\n"$colorOff
fi


# Clean unnecessary packages
echo -e $cyan"\n Cleaning unnecessary packages... \n"$colorOff
apt-get autoremove -y 