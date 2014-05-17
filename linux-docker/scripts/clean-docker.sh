#!/bin/bash

docker kill django
docker kill fuseki
docker kill existdb
docker kill postgres

DOCKER_EXIT=$(docker ps -a | grep 'Exit')
DOCKER_TRUNC=$(docker ps -a --no-trunc | grep 'Exit')

if [-n DOCKER_EXIT]; then
docker ps -a | grep 'Exit' | awk '{print $1}' | sudo xargs docker rm
fi

if [ -n DOCKER_TRUNC]; then
docker ps -a --no-trunc | grep 'Exit' | awk '{print $1}' | xargs -r docker rm
fi

docker rmi -f 0xffea/saucy-server-django
docker rmi -f 0xffea/saucy-server-postgres
docker rmi -f 0xffea/saucy-server-fuseki
docker rmi -f 0xffea/saucy-server-existdb

exit 0
