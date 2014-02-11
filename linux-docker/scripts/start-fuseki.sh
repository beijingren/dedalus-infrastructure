#!/bin/sh

#
# Fuseki
#

cd /root

# TODO: should be shared among containers (volume1)
/usr/bin/git clone https://github.com/beijingren/dublin-store.git

wget http://www.apache.org/dist/jena/binaries/jena-fuseki-1.0.1-distribution.tar.gz
tar xf jena-fuseki-1.0.1-distribution.tar.gz
cd jena-fuseki-1.0.1

# Start the server
./fuseki-server --mem --update --file /root/dublin-store/rdf/sikuquanshu.rdf /ds
