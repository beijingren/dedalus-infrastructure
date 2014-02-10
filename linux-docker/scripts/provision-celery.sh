#
# Celery container
#

docker kill /celery
docker rm /celery

docker build -t 0xffea/saucy-server-celery - <<EOL
FROM 0xffea/saucy-server-cloudimg-amd64
MAINTAINER David Höppner <0xffea@gmail.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu saucy universe" >> /etc/apt/sources.list

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y		\
	python-celery		\
	rabbitmq-server

RUN useradd -m -p "celery" celery

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/scripts/start-celery.sh /home/celery/start-celery.sh
RUN chmod 0755 /home/celery/start-django.sh

CMD ["/home/celery/start-celery.sh"]
EOL

docker run -d -name celery -t 0xffea/saucy-server-celery
