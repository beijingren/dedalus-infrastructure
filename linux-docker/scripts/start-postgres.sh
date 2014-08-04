#!/bin/bash

PASSWORD=$(cat /docker/master-password.txt)

echo "listen_addresses = '*'" >> /etc/postgresql/9.3/main/postgresql.conf
# XXX: fix in production
echo "hostssl all     all     0.0.0.0/0       md5" >> /etc/postgresql/9.3/main/pg_hba.conf

pg_ctlcluster 9.3 main start

su postgres -c psql <<EOL
create role docker superuser createdb password '${PASSWORD}' login;
create database docker owner docker;
EOL

su postgres -c psql <<EOL
create role django createdb password '${PASSWORD}' login;
create database django owner django;
EOL

tail -f /var/log/postgresql/postgresql-9.3-main.log
