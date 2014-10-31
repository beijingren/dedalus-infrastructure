#
# Solr container
#

docker kill solr
docker rm solr

docker build -t 0xffea/solr - <<EOL
FROM makuk66/docker-solr
MAINTAINER David Höppner <0xffea@gmail.com>

ADD https://raw.github.com/beijingren/dedalus-infrastructure/master/linux-docker/configs/solr/schema.xml /opt/solr-4.10.1/example/solr/collection1/

EXPOSE 8983
CMD ["/bin/bash", "-c", "/opt/solr/bin/solr -f"]
EOL

docker run -d -p 8983:8983 --name solr -v /docker:/docker:rw -t 0xffea/solr
