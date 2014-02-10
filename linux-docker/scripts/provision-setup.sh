
# Fix locale
locale-gen en_US.UTF-8

# Update the base system
apt-get update
apt-get -y upgrade
apt-get -qy install	\
	pwgen		\
	xsltproc

# Shared data diretory for all containers
mkdir -p /var/lib/volume1

pwgen 7 1 > /var/lib/volume1/master-password.txt
