#!/bin/sh

#
# Erlang
#

export LANG="en_US.UTF-8"

cd /root

curl -O http://www.erlang.org/download/otp_src_17.3.tar.gz
tar xf otp_src_17.3.tar.gz

cd otp_src_17.3
./configure
make install

#
# Elixir
#
cd /root
curl -LO https://github.com/elixir-lang/elixir/archive/v1.0.2.tar.gz
tar xf v1.0.2.tar.gz
cd elixir-1.0.2
make install

/usr/sbin/riak start

tail -f /docker/dublin-store/rdf/NamedIndividual.rdf
