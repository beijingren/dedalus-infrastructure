#
# Django container
#

DOCKER_PASSWORD=$(cat /var/lib/volume1/master-password.txt)

docker kill /django
docker rm /django

docker build -t 0xffea/saucy-server-django - <<EOL
FROM 0xffea/saucy-server-cloudimg-amd64
MAINTAINER David Höppner <0xffea@gmail.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu saucy universe" >> /etc/apt/sources.list

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get -qy install		\
	python-django		\
	python-django-mptt	\
	python-django-sekizai	\
	python-django-south	\
	python-imaging		\
	python-markdown		\
	python-pip		\
	python-psycopg2		\
	python-sorl-thumbnail	\
	apache2			\
	gettext			\
	git			\
	libapache2-mod-wsgi	\
	libpython-dev

RUN useradd -m -p "docker" docker

EXPOSE 80

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/scripts/start-django.sh /home/docker/start-django.sh
RUN chmod 0755 /home/docker/start-django.sh

CMD ["/home/docker/start-django.sh"]
EOL

docker run -d -e DOCKER_PASSWORD=${DOCKER_PASSWORD} -p 80:80 -name django -link postgres:db -v /var/lib/volume1:/docker/volume1:rw -t 0xffea/saucy-server-django
