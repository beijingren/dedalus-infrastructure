#!/bin/sh

#
# Fuseki
#

export LANG="en_US.UTF-8"

cd /root

wget http://mirror.23media.de/apache/jena/binaries/jena-fuseki1-1.3.0-distribution.tar.gz
tar xf jena-fuseki1-1.3.0-distribution.tar.gz

wget http://mirror.23media.de/apache/jena/binaries/apache-jena-3.0.0.tar.gz
tar xf apache-jena-3.0.0.tar.gz

#
# Convert OWL to RDF
#

#
# Start fuseki server
#
cd jena-fuseki1-1.3.0

chmod +x s-put

# Start the server
./fuseki-server --mem --update --file /docker/dublin-store/rdf/sikuquanshu.rdf /ds &

sleep 4

./s-put http://localhost:3030/ds/data default /docker/dublin-store/rdf/NamedIndividual.rdf

tail -f /docker/dublin-store/rdf/NamedIndividual.rdf
