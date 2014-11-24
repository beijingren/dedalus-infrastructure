#
# Riak container
#

docker kill riak
docker rm riak

docker build -t 0xffea/riak - <<EOL
FROM ubuntu:latest
MAINTAINER David Höppner <0xffea@gmail.com>

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -qy build-dep \
	erlang

EXPOSE 10017

RUN locale-gen en_US.UTF-8
RUN echo "LANG=en_US.UTF-8" > /etc/default/locale

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/linux-docker/scripts/start-postgres.sh /root/start-postgres.sh
RUN chmod 0755 /root/start-postgres.sh

CMD ["/root/start-postgres.sh"]
EOL

docker run -d --name riak -e LANG="en_US.UTF-8" -p 10017:10017 -v /docker:/docker:rw -t 0xffea/riak
