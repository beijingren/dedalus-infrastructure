#!/bin/sh

#
# Fuseki
#

cd /root

wget http://www.apache.org/dist/jena/binaries/jena-fuseki-1.0.1-distribution.tar.gz
tar xf jena-fuseki-1.0.1-distribution.tar.gz
cd jena-fuseki-1.0.1

# Start the server
./fuseki-server --mem --update --file /docker/dublin-store/rdf/sikuquanshu.rdf /ds
