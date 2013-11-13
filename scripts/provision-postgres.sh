#
# Postgres container
#

docker build -t 0xffea/saucy-server-postgres - <<EOL
FROM 0xffea/saucy-server-cloudimg-amd64
MAINTAINER David Höppner <0xffea@gmail.com>

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install postgresql

EXPOSE 5432

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/scripts/start-postgres.sh /root/start-postgres.sh
RUN chmod 0755 /root/start-postgres.sh

CMD ["/root/start-postgres.sh"]
EOL

docker run -d -name postgres -p 5432:5432 -t 0xffea/saucy-server-postgres
