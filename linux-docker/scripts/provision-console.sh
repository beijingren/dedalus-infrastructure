#
# Django container
#

PASSWORD=$(cat /docker/master-password.txt)

docker kill console
docker rm console

docker build -t 0xffea/saucy-server-console - <<EOL
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
	postgresql-client	\
	libpython-dev		\
	vim

RUN useradd -m -p "docker" docker
RUN locale-gen en_US.UTF-8
RUN export LANG=en_US.UTF-8
RUN echo "LANG=en_US.UTF-8" > /etc/default/locale
EOL

docker run -i --privileged -e DOCKER_PASSWORD=${PASSWORD} -e LANG="en_US.UTF-8" -p 8001:8001 --name console --link postgres:db --link existdb:xmldb --link fuseki:sparql -v /docker:/docker:rw -t 0xffea/saucy-server-console /bin/bash
