#
# Django container
#

docker build -t 0xffea/saucy-server-django - <<EOL
FROM 0xffea/saucy-server-cloudimg-amd64
MAINTAINER David Höppner <0xffea@gmail.com>

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install 	\
	python-django	\
	apache2		\
	libapache2-mod-wsgi	\
#postgresql-client-common

EXPOSE 80

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/scripts/django-start.sh /django-start.sh
RUN chmod 0755 /django-start.sh

CMD ["/django-start.sh"]
EOL

docker run -p 80:80 -d -t 0xffea/saucy-server-django
