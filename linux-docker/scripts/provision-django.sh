#
# Django container
#

PASSWORD=$(cat /docker/master-password.txt)

docker kill django
docker rm django

docker build -t 0xffea/saucy-server-django - <<EOL
FROM ubuntu:13.10
MAINTAINER David Höppner <0xffea@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -qy --force-yes install		\
	python-lxml		\
	python-libxslt1		\
	python-libxml2		\
	python-pip		\
	python-ply		\
	python-psycopg2		\
	apache2			\
	fonts-droid		\
	gettext			\
	git			\
	openjdk-7-jre-headless	\
	libapache2-mod-wsgi	\
	libapache2-mod-proxy-html \
	libpython-dev		\
	tesseract-ocr		\
	tesseract-ocr-chi-tra

RUN useradd -m -p "docker" docker
RUN locale-gen en_US.UTF-8
RUN export LANG=en_US.UTF-8
RUN echo "LANG=en_US.UTF-8" > /etc/default/locale

RUN pip install django django-leaflet fpdf lxml pinyin psycopg2 python-creole requests wikipedia pika eulxml eulexistdb SPARQLWrapper
RUN pip install git+https://github.com/arafalov/sunburnt

RUN a2dismod mpm_event
RUN a2enmod mpm_prefork
RUN a2enmod proxy
RUN a2enmod proxy_html
RUN a2enmod proxy_http 
RUN a2enmod proxy_wstunnel
RUN a2enmod headers
RUN a2enmod xml2enc

EXPOSE 80
EXPOSE 11211

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/linux-docker/scripts/start-django.sh /home/docker/start-django.sh
RUN chmod 0755 /home/docker/start-django.sh

CMD ["/home/docker/start-django.sh"]
EOL

docker run -d --privileged -e DOCKER_PASSWORD=${PASSWORD} -e LANG="en_US.UTF-8" -p 80:80 -p 11211:11211 --name django --link postgres:db --link existdb:xmldb --link fuseki:sparql --link celery:rabbitmq --link julia:julia --link solr:solr -v /docker:/docker:rw -t 0xffea/saucy-server-django
