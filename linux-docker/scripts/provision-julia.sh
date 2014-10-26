#
# Julia container
#

docker kill julia
docker rm julia

docker build -t 0xffea/julia - <<EOL
FROM ubuntu:latest
MAINTAINER David Höppner <0xffea@gmail.com>

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update && RUN apt-get -qy install software-properties-common

RUN add-apt-repository --yes ppa:staticfloat/juliareleases
RUN apt-get update && RUN apt-get -qy install		\
	julia	\
	ipython	\
	ipython-notebook \
	libzmq-dev

RUN julia -e 'Pkg.add("IJulia")'

EXPOSE 8998

ENTRYPOINT ipython notebook --profile julia
EOL

docker run -d -e LANG="en_US.UTF-8" -p 8998:8998  --name julia -v /docker:/docker:rw -t 0xffea/julia
