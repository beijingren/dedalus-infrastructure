#
# Existdb container
#

docker kill existdb
docker rm existdb

docker build -t 0xffea/saucy-server-existdb - <<EOL
FROM 0xffea/saucy-server-existdb-amd64
MAINTAINER David Höppner <0xffea@gmail.com>

EXPOSE 8080 8443

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/linux-docker/scripts/start-existdb.sh /start-existdb.sh
RUN chmod 0755 /start-existdb.sh

CMD ["/start-existdb.sh"]
EOL

docker run -d --name existdb -p 8080:8080 -v /docker:/docker:rw -t 0xffea/saucy-server-existdb
