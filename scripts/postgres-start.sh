#!/bin/bash

pg_ctlcluster 9.1 main start

tail -f /var/log/postgresql/postgresql-9.1-main.log
