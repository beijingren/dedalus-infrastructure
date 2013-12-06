#
# Fuseki container
#

docker kill /fuseki
docker rm /fuseki

docker build -t 0xffea/saucy-server-fuseki - <<EOL
FROM 0xffea/saucy-server-existdb-amd64
MAINTAINER David Höppner <0xffea@gmail.com>

EXPOSE 3030

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/scripts/start-fuseki.sh /root/start-fuseki.sh
RUN chmod 0755 /root/start-fuseki.sh

CMD ["/root/start-fuseki.sh"]
EOL

docker run -d -name fuseki -p 3030:3030 -v /var/lib/volume1:/docker/volume1:rw -t 0xffea/saucy-server-fuseki