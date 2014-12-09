#
# Riak container
#

docker kill riak
docker rm riak

docker build -t 0xffea/riak - <<EOL
FROM ubuntu:latest
MAINTAINER David Höppner <0xffea@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -qy build-dep \
	erlang
RUN apt-get -qy install	\
	curl

WORKDIR /root
RUN curl -O http://s3.amazonaws.com/downloads.basho.com/riak/2.0/2.0.2/ubuntu/trusty/riak_2.0.2-1_amd64.deb
RUN dpkg -i riak_2.0.2-1_amd64.deb

EXPOSE 10017

RUN locale-gen en_US.UTF-8
RUN echo "LANG=en_US.UTF-8" > /etc/default/locale

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/linux-docker/scripts/start-riak.sh /root/start-riak.sh
RUN chmod 0755 /root/start-riak.sh

CMD ["/root/start-riak.sh"]
EOL

docker run -d --name riak -e LANG="en_US.UTF-8" -p 10017:10017 -v /docker:/docker:rw -t 0xffea/riak
