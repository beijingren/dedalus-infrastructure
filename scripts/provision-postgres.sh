#
# Postgres container
#

docker build -t 0xffea/saucy-server-postgres - <<EOL
FROM 0xffea/raring-server-cloudimg-amd64
MAINTAINER David Höppner <0xffea@gmail.com>

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install postgresql

EXPOSE 5432

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/scripts/postgres-start.sh /postgres-start.sh
RUN chmod 0755 /postgres-start.sh

CMD ["/postgres-start.sh"]
EOL

docker run -d -p 5432:5432 -t 0xffea/saucy-server-postgres
