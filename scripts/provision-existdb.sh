#
# Existdb container
#

docker build -t 0xffea/saucy-server-existdb - <<EOL
FROM 0xffea/saucy-server-cloudimg-amd64
MAINTAINER David Höppner <0xffea@gmail.com>

RUN apt-get -y install		\
	openjdk-7-jdk           \
	openjdk-7-jre-headless  \
	openjdk-7-jre-lib


ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/scripts/existdb-start.sh /existdb-start.sh
RUN chmod 0755 /existdb-start.sh

CMD ["/existdb-start.sh"]
EOL

docker run -d -t 0xffea/saucy-server-existdb
