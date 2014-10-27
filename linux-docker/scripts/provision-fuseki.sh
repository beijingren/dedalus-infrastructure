#
# Fuseki container
#

docker kill fuseki
docker rm fuseki

docker build -t 0xffea/saucy-server-fuseki - <<EOL
FROM 0xffea/saucy-server-existdb-amd64
MAINTAINER David Höppner <0xffea@gmail.com>

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -qy install		\
	git

RUN locale-gen en_US.UTF-8
RUN export LANG=en_US.UTF-8
RUN echo "LANG=en_US.UTF-8" > /etc/default/locale

EXPOSE 3030

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/linux-docker/scripts/start-fuseki.sh /root/start-fuseki.sh
RUN chmod 0755 /root/start-fuseki.sh

CMD ["/root/start-fuseki.sh"]
EOL

docker run -d --name fuseki -p 3030:3030 -v /docker:/docker:rw -t 0xffea/saucy-server-fuseki
