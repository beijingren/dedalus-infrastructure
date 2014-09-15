#!/bin/bash

#docker kill django
#docker kill fuseki
#docker kill existdb
#docker kill postgres

#docker rm django
#docker rm fuseki
#docker rm existdb
#docker rm postgres

docker ps -a | grep 'Exit' | awk '{print $1}' | sudo xargs docker rm
docker ps -a --no-trunc | grep 'Exit' | awk '{print $1}' | xargs -r docker rm

#docker rmi -f 0xffea/saucy-server-django
#docker rmi -f 0xffea/saucy-server-postgres
#docker rmi -f 0xffea/saucy-server-fuseki
#docker rmi -f 0xffea/saucy-server-existdb

exit 0
