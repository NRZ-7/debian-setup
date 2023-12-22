# DOCUMENTATION:
# https://wiki.debian.org/VirtualBox
# https://fasttrack.debian.net/

# DISCLAIMER: I'm uncertain why these two lines are included in the Debian official documentation, as these repositories don't appear to be relevant in Debian 12. If my understanding is incorrect, please feel free to contact me via email or leave a comment.
# echo "deb http://deb.debian.org/debian $(lsb_release -cs)-backports main contrib" |sudo tee /etc/apt/sources.list.d/backports.list
# echo "deb http://fasttrack.debian.net/debian-fasttrack/ $(lsb_release -cs)-backports-staging main contrib" | sudo tee -a /etc/apt/sources.list.d/fasttrack.list

echo -e $cyan"\n Installing Virtualbox Guest Additions for X11 \n"$colorOff

# Install the lsb-release package to get information about the Debian release
# apt install lsb-release -y

# Install the fasttrack-archive-keyring package
apt install fasttrack-archive-keyring -y
# Add the fasttrack repository to the sources.list.d directory
echo "deb http://fasttrack.debian.net/debian-fasttrack/ $(lsb_release -cs)-fasttrack main contrib" | tee /etc/apt/sources.list.d/fasttrack.list

# Update the package list to include the fasttrack repository
apt update
# Install the VirtualBox Guest Additions for X11
apt install virtualbox-guest-x11 -y

echo -e $green" Virtualbox Guest Additions for X11 is installed"$colorOff