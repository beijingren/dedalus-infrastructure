#
# Postgres container
#

docker build -t 0xffea/raring-server-postgres - <<EOL
FROM 0xffea/raring-server-cloudimg-amd64
MAINTAINER David Höppner <0xffea@gmail.com>

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install postgresql

EXPOSE 5432

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/scripts/postgres-start.sh /postgres-start.sh
RUN chmod 0755 /postgres-start.sh

CMD ["/postgres-start.sh"]
EOL

docker run -d 0xffea/raring-server-postgres
