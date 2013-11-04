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


ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/scripts/start-existdb.sh /root/start-existdb.sh
RUN chmod 0755 /root/start-existdb.sh

CMD ["/start-existdb.sh"]
EOL

docker run -d -t 0xffea/saucy-server-existdb
