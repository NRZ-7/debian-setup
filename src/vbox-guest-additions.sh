#https://wiki.debian.org/VirtualBox

# Install the lsb-release package to get information about the Debian release
apt install lsb-release -y
# Install the fasttrack-archive-keyring package
apt install fasttrack-archive-keyring -y
# Add the fasttrack repository to the sources.list.d directory
echo "deb http://fasttrack.debian.net/debian-fasttrack/ $(lsb_release -cs)-fasttrack main contrib" | tee /etc/apt/sources.list.d/fasttrack.list
# Update the package list to include the fasttrack repository
apt update
# Install the VirtualBox Guest Additions for X11
apt install virtualbox-guest-x11 -y