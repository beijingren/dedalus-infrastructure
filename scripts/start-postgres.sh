#!/bin/bash

MASTER_PASSWORD=$(cat /docker-volume1/master-password.txt)

# XXX: fix in production
echo "listen_addresses = '*'" >> /etc/postgresql/9.1/main/postgresql.conf
echo "hostssl all     all     0.0.0.0/0       md5" >> /etc/postgresql/9.1/main/pg_hba.conf

pg_ctlcluster 9.1 main start

# XXX: fix in production
su postgres -c psql <<EOL
create role docker superuser createdb password '${MASTER_PASSWORD}' login;
create database docker owner docker;
EOL

tail -f /var/log/postgresql/postgresql-9.1-main.log
