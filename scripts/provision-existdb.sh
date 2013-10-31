#
# Existdb container
#

docker build -t 0xffea/raring-server-existdb - <<EOL
FROM 0xffea/raring-server-cloudimg-amd64
MAINTAINER David Höppner <0xffea@gmail.com>

EOL

docker run -d -t 0xffea/raring-server-existdb
