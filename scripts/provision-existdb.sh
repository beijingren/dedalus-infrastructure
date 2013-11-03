#
# Existdb container
#

docker build -t 0xffea/saucy-server-existdb - <<EOL
FROM 0xffea/raring-server-cloudimg-amd64
MAINTAINER David Höppner <0xffea@gmail.com>

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/scripts/existdb-start.sh /existdb-start.sh
RUN chmod 0755 /existdb-start.sh

CMD ["/existdb-start.sh"]
EOL

docker run -d -t 0xffea/saucy-server-existdb
