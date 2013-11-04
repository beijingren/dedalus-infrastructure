#
# Setup Docker
#

/usr/bin/apt-get -y install	\
	wget			\
	git

# Get Docker key and update source lists
/bin/sh -c "/usr/bin/wget -qO- https://get.docker.io/gpg | apt-key add -"
/bin/sh -c "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"

# Install Docker
/usr/bin/apt-get update
/usr/bin/apt-get -y install		\
	linux-image-extra-`uname -r`	\
	lxc-docker

# Load overlay filesystem
modprobe aufs
