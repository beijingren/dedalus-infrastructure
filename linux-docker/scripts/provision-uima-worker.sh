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
	python-pika		\
	openjdk-7-jre-headless

RUN useradd -m -p "uima" uima

RUN locale-gen en_US.UTF-8
RUN echo "LANG=en_US.UTF-8" > /etc/default/locale

RUN git config --global user.name "Beijingren"
RUN git config --global user.email "0xffea@gmail.com"
RUN git config --global push.default simple

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/linux-docker/scripts/uima-worker.py /home/uima/uima-worker.py
RUN chmod 0755 /home/uima/uima-worker.py

CMD ["/home/uima/uima-worker.py"]
EOL

docker run -d --name uima-worker-01 -e LANG="en_US.UTF-8" --link celery:rabbitmq -v /docker:/docker:rw -v /root:/root:rw -t 0xffea/saucy-server-uima
