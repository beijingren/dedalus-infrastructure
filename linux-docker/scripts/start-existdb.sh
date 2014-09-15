#!/bin/bash
#
# eXist-db
#

export LANG="en_US.UTF-8"

# Start the server
# TODO: should be daemon mode
/usr/local/existdb/tools/wrapper/bin/wrapper-linux-x86-64 -c ../conf/wrapper.conf

# TODO: should be server log
/usr/bin/tail -f /usr/local/existdb/tools/wrapper/logs/wrapper.log
