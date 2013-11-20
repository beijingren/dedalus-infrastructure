#!/bin/bash
#
# eXist-db
#

cd /tmp

# Get XML documents
/usr/bin/git clone https://github.com/beijingren/dublin-store.git

# Start the server
# TODO: should be daemon mode
/usr/local/existdb/tools/wrapper/bin/wrapper-linux-x86-64 -c ../conf/wrapper.conf

/bin/sleep 30s

# Load documents into the db
/usr/local/existdb/bin/client.sh -u admin -P glen32 -m /db/docker -p /tmp/dublin-store/db/test_001.xml

# TODO: should be server log
/usr/bin/tail -f /usr/local/existdb/tools/wrapper/logs/wrapper.log
