#
# Django container
#

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
	python-psycopg2		\
	python-sorl-thumbnail	\
	apache2			\
	gettext			\
	git			\
	libapache2-mod-wsgi	\
	pip

RUN useradd -m -p "docker" docker

EXPOSE 80

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/scripts/start-django.sh /home/docker/start-django.sh
RUN chmod 0755 /home/docker/start-django.sh

CMD ["/home/docker/start-django.sh"]
EOL

docker run -p 80:80 -d -name django -t 0xffea/saucy-server-django
