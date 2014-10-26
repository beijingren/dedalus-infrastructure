
DUBLIN=dublin-store
ROCHE=roche-website
DEDALUS=dedalus-infrastructure
BERTIE=bertie-uima

# Delete local changes if reprovision
rm -rf /docker

# Shared data diretory for all containers
mkdir -p /docker/apache2
mkdir -p /docker/julia

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

if test -d ${BERTIE}; then
	cd ${BERTIE}; git pull; cd -
else
	git clone https://github.com/beijingren/${BERTIE}.git
fi
