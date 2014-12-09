#
# Julia container
#

docker kill julia
docker rm julia

docker build -t 0xffea/julia - <<EOL
FROM ubuntu:latest
MAINTAINER David Höppner <0xffea@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -qy install software-properties-common

RUN add-apt-repository --yes ppa:staticfloat/juliareleases
RUN apt-get update && apt-get -qy install \
	julia		\
	python-pip	\
	libpython-dev	\
	libzmq-dev

RUN pip install ipython[notebook]

WORKDIR /docker/julia
RUN julia -e 'Pkg.add("IJulia")'
RUN julia -e 'Pkg.add("Gadfly")'

EXPOSE 8998

CMD ipython notebook --profile julia --ip=* --no-browser \
	--NotebookApp.webapp_settings="{'static_url_prefix':'/julia/static/'}" --port 8998 \
	--NotebookApp.base_project_url='/julia/' \
	--NotebookApp.base_kernel_url='/julia/'
EOL

docker run -d -e LANG="en_US.UTF-8" -p 8998:8998  --name julia -v /docker:/docker:rw -t 0xffea/julia
