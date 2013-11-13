#!/bin/bash

pg_ctlcluster 9.1 main start

# XXX: fix password in production
su postgres -c psql <<EOL
create role docker superuser createdb password 'docker' login;
EOL

echo "listen_addresses = '*'" >> /etc/postgresql/9.1/main/postgresql.conf
echo "hostssl all     all     0.0.0.0/0       md5" >> /etc/postgresql/9.1/main/pg_hba.conf

#su postgres -c "createdb -O docker docker"

tail -f /var/log/postgresql/postgresql-9.1-main.log
