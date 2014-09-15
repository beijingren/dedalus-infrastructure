#!/bin/sh

#
# Fuseki
#

export LANG="en_US.UTF-8"

cd /root

wget http://www.apache.org/dist/jena/binaries/jena-fuseki-1.1.0-distribution.tar.gz
tar xf jena-fuseki-1.1.0-distribution.tar.gz

wget http://ftp.fau.de/apache//jena/binaries/apache-jena-2.12.0.tar.gz
tar xf apache-jena-2.12.0.tar.gz

#
# Convert OWL to RDF
#

#
# Start fuseki server
#
cd jena-fuseki-1.1.0

chmod +x s-put

# Start the server
./fuseki-server --mem --update --file /docker/dublin-store/rdf/sikuquanshu.rdf /ds &

sleep 4

./s-put http://localhost:3030/ds/data default /docker/dublin-store/rdf/NamedIndividual.rdf

tail -f /docker/dublin-store/rdf/NamedIndividual.rdf
