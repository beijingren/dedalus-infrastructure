#!/bin/sh

#
# Erlang
#

export LANG="en_US.UTF-8"

cd /root

wget http://www.erlang.org/download/otp_src_17.3.tar.gz
tar xf otp_src_17.3.tar.gz

cd otp_src_17.3
./configure
make install

tail -f /docker/dublin-store/rdf/NamedIndividual.rdf
