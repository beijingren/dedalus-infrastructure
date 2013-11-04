#
# Django container
#

docker build -t 0xffea/saucy-server-django - <<EOL
FROM 0xffea/saucy-server-cloudimg-amd64
MAINTAINER David Höppner <0xffea@gmail.com>

RUN apt-get -y install		\
	python-django		\
	python-psycopg2		\
	apache2			\
	libapache2-mod-wsgi	\
	git

EXPOSE 80

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/scripts/start-django.sh /root/django-start.sh
RUN chmod 0755 /root/django-start.sh

CMD ["/start-django.sh"]
EOL

docker run -p 80:80 -d -t 0xffea/saucy-server-django
