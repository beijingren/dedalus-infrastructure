#!/bin/bash

pg_ctlcluster 9.1 main start

su postgres -c psql <<EOL
create role docker nosuperuser nocreatedb;
EOL

su postgres -c "createdb docker"

tail -f /var/log/postgresql/postgresql-9.1-main.log
