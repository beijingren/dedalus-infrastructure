#
# Celery container
#

docker kill /celery
docker rm /celery

docker build -t 0xffea/saucy-server-celery - <<EOL
FROM ubuntu:latest
MAINTAINER David Höppner <0xffea@gmail.com>

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y		\
	python-celery		\
	rabbitmq-server

RUN useradd -m -p "celery" celery
RUN locale-gen en_US.UTF-8
RUN export LANG=en_US.UTF-8
RUN echo "LANG=en_US.UTF-8" > /etc/default/locale

EXPOSE 5672

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/scripts/start-celery.sh /home/celery/start-celery.sh
RUN chmod 0755 /home/celery/start-celery.sh

CMD ["/home/celery/start-celery.sh"]
EOL

docker run -d --name celery -p 5672:5672 -v /docker:/docker:rw -t 0xffea/saucy-server-celery
