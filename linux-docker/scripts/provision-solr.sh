#
# Solr container
#

docker kill solr
docker rm solr

docker run -d -p 8983:8983  -v /docker:/docker:rw -t makuk66/docker-solr
