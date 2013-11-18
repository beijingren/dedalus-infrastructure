#!/bin/bash
#
# Django WSGI application
#
#

cd /home/docker

# Get the web application
/usr/bin/git clone https://github.com/beijingren/roche-website.git

# Get the config files
/usr/bin/git clone https://github.com/beijingren/dedalus-infrastructure.git

# Install apache WSGI config
cp /home/docker/dedalus-infrastructure/configs/apache2/000-default.conf /etc/apache2/sites-available/
cat /home/docker/dedalus-infrastructure/configs/apache2/apache2.conf >> /etc/apache2/apache2.conf

# TODO: kind of ugly. is there are a better way todo this?
echo "export DOCKER_PASSWORD=${DOCKER_PASSWORD}" >> /etc/apache2/envvars
echo "export DB_PORT_5432_TCP_ADDR=${DB_PORT_5432_TCP_ADDR}" >> /etc/apache2/envvars
echo "export DB_PORT_5432_TCP_PORT=${DB_PORT_5432_TCP_PORT}" >> /etc/apache2/envvars
echo "export XMLDB_PORT_8080_TCP_ADDR=${XMLDB_PORT_8080_TCP_ADDR}" >> /etc/apache2/envvars
echo "export XMLDB_PORT_8080_TCP_PORT=${XMLDB_PORT_8080_TCP_PORT}" >> /etc/apache2/envvars

cd /home/docker/roche-website

# Install requirements
pip install -r requirements.txt

# Sync database
python manage.py syncdb --noinput

# Generate L18N
python manage.py compilemessages

# Serve the Django WSGI application
rm /var/run/apache2/apache2.pid
/etc/init.d/apache2 start

tail -f /var/log/apache2/error.log
