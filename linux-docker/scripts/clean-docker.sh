#!/bin/bash

docker kill django
docker kill fuseki
docker kill existdb
docker kill postgres

docker ps -a | grep Exit | awk '{print $1}' | sudo xargs docker rm || true
docker ps -a --no-trunc | grep 'Exit' | awk '{print $1}' | xargs -r docker rm || true

docker rmi -f 0xffea/saucy-server-django
docker rmi -f 0xffea/saucy-server-postgres
docker rmi -f 0xffea/saucy-server-fuseki
docker rmi -f 0xffea/saucy-server-existdb
