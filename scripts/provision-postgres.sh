#
# Postgres container
#

docker build -t 0xffea/raring-server-postgres - <<EOL
FROM 0xffea/raring-server-cloudimg-amd64
MAINTAINER David Höppner <0xffea@gmail.com>

RUN apt-get -y install postgresql
EOL
