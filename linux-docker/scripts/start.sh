#!/bin/bash

sh provision-setup.sh
sh clean-docker.sh

sh provision-existdb.sh
sleep 2
sh provision-postgres.sh
sh provision-celery.sh
sh provision-fuseki.sh
sh provision-julia.sh
sh provision-solr.sh
sh provision-uima-plain-worker.sh
sh provision-uima-worker.sh
sh provision-django.sh

docker run -i  -e DOCKER_PASSWORD=${PASSWORD} -e DJANGO_SETTINGS_MODULE="roche.settings" -e LANG="en_US.UTF-8" --link postgres:db --link existdb:xmldb --link fuseki:sparql --link celery:rabbitmq --link julia:julia --link solr:solr -v /docker:/docker:rw -t 0xffea/saucy-server-django /bin/bash -c "(cd /docker/roche-website; python roche/scripts/xml-load.py)"
