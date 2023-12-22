apt install lsb-release
#echo "deb http://deb.debian.org/debian $(lsb_release -cs)-backports main contrib" | tee /etc/apt/sources.list.d/backports.list
apt install fasttrack-archive-keyring
echo "deb http://fasttrack.debian.net/debian-fasttrack/ $(lsb_release -cs)-fasttrack main contrib" | tee /etc/apt/sources.list.d/fasttrack.list
#echo "deb http://fasttrack.debian.net/debian-fasttrack/ $(lsb_release -cs)-backports-staging main contrib" | tee -a /etc/apt/sources.list.d/fasttrack.list
apt update
#apt install virtualbox virtualbox-ext-pack
apt install virtualbox-guest-x11