#!/bin/sh

#
# Fuseki
#

cd /root

wget http://www.apache.org/dist/jena/binaries/jena-fuseki-1.1.0-distribution.tar.gz
tar xf jena-fuseki-1.1.0-distribution.tar.gz
cd jena-fuseki-1.1.0

chmod +x s-put

# Start the server
./fuseki-server --mem --update --file /docker/dublin-store/rdf/sikuquanshu.rdf /ds &

sleep 4

./s-put http://localhost:3030/ds/data default /docker/dublin-store/rdf/NamedIndividual.rdf

tail -f /docker/dublin-store/rdf/NamedIndividual.rdf
