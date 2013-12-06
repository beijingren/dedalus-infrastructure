#
# Fuseki
#

cd

wget http://www.apache.org/dist/jena/binaries/jena-fuseki-1.0.0-distribution.tar.gz
tar xf jena-fuseki-1.0.0-distribution.tar.gz
cd jena-fuseki-1.0.0

# Start the server
./fuseki start

# TODO
tail -f NOTICE
