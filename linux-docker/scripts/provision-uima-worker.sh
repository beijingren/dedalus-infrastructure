#
# UIMA collection worker container
#

docker kill uima-worker-01
docker rm uima-worker-01

docker build -t 0xffea/saucy-server-uima - <<EOL
FROM ubuntu:13.10
MAINTAINER David Höppner <0xffea@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN sed -i -e "s/archive/old-releases/" /etc/apt/sources.list
RUN apt-get update && apt-get -qy install		\
	git			\
	python-pika		\
	python-lxml		\
	python-pip		\
	libpython-dev		\
	openjdk-7-jre-headless

RUN useradd -m -p "uima" uima

RUN locale-gen en_US.UTF-8
RUN echo "LANG=en_US.UTF-8" > /etc/default/locale

RUN git config --global user.name "北京人"
RUN git config --global user.email "schlick.moritz1@gmail.com"
RUN git config --global push.default simple

RUN pip install eulexistdb

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/linux-docker/scripts/uima-worker.py /home/uima/uima-worker.py
RUN chmod 0755 /home/uima/uima-worker.py

CMD ["/home/uima/uima-worker.py"]
EOL

#
# /root/.ssh/config
#
# Host github.com
#     User beijingren
#     IdentityFile /docker/github_rsa

docker run -d --privileged --name uima-worker-01 -e LANG="en_US.UTF-8" --restart="always" --link celery:rabbitmq --link existdb:xmldb -v /docker:/docker:rw -v /root:/root:rw -t 0xffea/saucy-server-uima
