#
# Django container
#

docker kill uima-worker-01
docker rm uima-worker-01

docker build -t 0xffea/saucy-server-uima - <<EOL
FROM ubuntu:13.10
MAINTAINER David Höppner <0xffea@gmail.com>

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get -qy install		\
	git			\
	openjdk-7-jre-headless

RUN useradd -m -p "uima" uima
RUN locale-gen en_US.UTF-8
RUN echo "LANG=en_US.UTF-8" > /etc/default/locale

ADD scripts/start-uima-worker.sh /home/uima/start-uima-worker.sh
RUN chmod 0755 /home/docker/start-uima-worker.sh

CMD ["/home/docker/start-uima-worker.sh"]
EOL

docker run -d --privileged --name uima-worker-01 --link postgres:db --link existdb:xmldb --link fuseki:sparql --link celery:rabbitmq -v /docker:/docker:rw -t 0xffea/saucy-server-uima
