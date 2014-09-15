#
# Django container
#

PASSWORD=$(cat /docker/master-password.txt)

docker kill django
docker rm django

docker build -t 0xffea/saucy-server-django - <<EOL
FROM ubuntu:13.10
MAINTAINER David Höppner <0xffea@gmail.com>

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get -qy --force-yes install		\
	python-lxml		\
	python-pip		\
	python-ply		\
	python-psycopg2		\
	apache2			\
	fonts-droid		\
	gettext			\
	git			\
	openjdk-7-jre-headless	\
	libapache2-mod-wsgi	\
	libpython-dev

RUN useradd -m -p "docker" docker
RUN locale-gen en_US.UTF-8
RUN LANG=en_US.UTF-8
EOL

docker run -i --privileged -e DOCKER_PASSWORD=${PASSWORD} -p 80:80 -p 11211:11211 --name django --link postgres:db --link existdb:xmldb --link fuseki:sparql -v /docker:/docker:rw -t 0xffea/saucy-server-django /bin/bash
