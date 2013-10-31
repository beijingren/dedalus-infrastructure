#
# Django container
#

docker build -t 0xffea/raring-server-django - <<EOL
FROM 0xffea/raring-server-cloudimg-amd64
MAINTAINER David Höppner <0xffea@gmail.com>

RUN apt-get -y install	\
	python-django	\
	apache2		\
	libapache2-mod-wsgi	'\
	postgresql-client-common

EXPOSE 80

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/scripts/django-start.sh /django-start.sh
RUN chmod 0755 /django-start.sh

CMD ["/django-start.sh"]
EOL
