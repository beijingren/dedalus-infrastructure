#
# Existdb container
#

docker kill /existdb
docker rm /existdb

docker build -t 0xffea/saucy-server-existdb - <<EOL
FROM 0xffea/saucy-server-existdb-amd64
MAINTAINER David Höppner <0xffea@gmail.com>

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get -qy install	\
	git

EXPOSE 8080 8443

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/scripts/start-existdb.sh /root/start-existdb.sh
RUN chmod 0755 /root/start-existdb.sh

CMD ["/root/start-existdb.sh"]
EOL

docker run -d -privileged -name existdb -p 8080:8080 -t 0xffea/saucy-server-existdb
