#
# Postgres container
#

docker kill postgres
docker rm postgres

docker build -t 0xffea/server-postgres - <<EOL
FROM ubuntu:latest
MAINTAINER David Höppner <0xffea@gmail.com>

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get -qy install		\
	postgresql

EXPOSE 5432
RUN locale-gen en_US.UTF-8
RUN export LANG=en_US.UTF-8
RUN echo "LANG=en_US.UTF-8" > /etc/default/locale

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/linux-docker/scripts/start-postgres.sh /root/start-postgres.sh
RUN chmod 0755 /root/start-postgres.sh

CMD ["/root/start-postgres.sh"]
EOL

docker run -d --name postgres -p 5432:5432 -v /docker:/docker:rw -t 0xffea/server-postgres
