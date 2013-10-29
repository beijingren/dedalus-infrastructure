#
# Django container
#

docker build -t 0xffea/raring-server-django - <<EOL
FROM 0xffea/raring-server-cloudimg-amd64
MAINTAINER David Höppner <0xffea@gmail.com>

RUN apt-get -y install python-django apache2

EXPOSE 80
EOL
