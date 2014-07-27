
DUBLIN=dublin-store
ROCHE=roche-website
DEDALUS=dedalus-infrastructure

# Shared data diretory for all containers
mkdir -p /docker/apache2

echo -n "iSoof4Vo" > /docker/master-password.txt

# Clone or update repos
cd /docker

if test -d ${DUBLIN}; then
	cd ${DUBLIN}; git pull; cd -;
else
	git clone https://github.com/beijingren/${DUBLIN}.git
fi

if test -d ${ROCHE}; then
	cd ${ROCHE}; git pull; cd -;
else
	git clone https://github.com/beijingren/${ROCHE}.git
fi

if test -d ${DEDALUS}; then
	cd ${DEDALUS}; git pull; cd -
else
	git clone https://github.com/beijingren/${DEDALUS}.git
fi
