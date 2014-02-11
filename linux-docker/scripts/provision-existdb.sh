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

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/scripts/linux-docker/start-existdb.sh /start-existdb.sh
RUN chmod 0755 /start-existdb.sh

CMD ["/start-existdb.sh"]
EOL

docker run -d -privileged -name existdb -p 8080:8080 -v /var/lib/volume1:/docker/volume1:rw -t 0xffea/saucy-server-existdb
