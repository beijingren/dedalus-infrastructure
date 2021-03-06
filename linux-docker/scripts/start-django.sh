#!/bin/bash
#
# Django WSGI application
#
#

# Install apache WSGI config
cp /docker/dedalus-infrastructure/linux-docker/configs/apache2/000-default.conf /etc/apache2/sites-available/
cat /docker/dedalus-infrastructure/linux-docker/configs/apache2/apache2.conf >> /etc/apache2/apache2.conf

# TODO: kind of ugly. is there are a better way todo this?
echo "export DOCKER_PASSWORD=${DOCKER_PASSWORD}" >> /etc/apache2/envvars
echo "export DB_PORT_5432_TCP_ADDR=${DB_PORT_5432_TCP_ADDR}" >> /etc/apache2/envvars
echo "export DB_PORT_5432_TCP_PORT=${DB_PORT_5432_TCP_PORT}" >> /etc/apache2/envvars
echo "export XMLDB_PORT_8080_TCP_ADDR=${XMLDB_PORT_8080_TCP_ADDR}" >> /etc/apache2/envvars
echo "export XMLDB_PORT_8080_TCP_PORT=${XMLDB_PORT_8080_TCP_PORT}" >> /etc/apache2/envvars
echo "export SPARQL_PORT_3030_TCP_ADDR=${SPARQL_PORT_3030_TCP_ADDR}" >> /etc/apache2/envvars
echo "export SPARQL_PORT_3030_TCP_PORT=${SPARQL_PORT_3030_TCP_PORT}" >> /etc/apache2/envvars
echo "export RABBITMQ_PORT_5672_TCP_ADDR=${RABBITMQ_PORT_5672_TCP_ADDR}" >> /etc/apache2/envvars
echo "export RABBITMQ_PORT_5672_TCP_PORT=${RABBITMQ_PORT_5672_TCP_PORT}" >> /etc/apache2/envvars
echo "export JULIA_PORT_8998_TCP_ADDR=${JULIA_PORT_8998_TCP_ADDR}" >> /etc/apache2/envvars
echo "export JULIA_PORT_8998_TCP_PORT=${JULIA_PORT_8998_TCP_PORT}" >> /etc/apache2/envvars
echo "export SOLR_PORT_8983_TCP_ADDR=${SOLR_PORT_8983_TCP_ADDR}" >> /etc/apache2/envvars
echo "export SOLR_PORT_8983_TCP_PORT=${SOLR_PORT_8983_TCP_PORT}" >> /etc/apache2/envvars

echo "export LANG='en_US.UTF-8'" >> /etc/apache2/envvars
echo "export LC_ALL='en_US.UTF-8'" >> /etc/apache2/envvars

#
# Set postgres client encoding
#
export PGCLIENTENCODING="UTF8"
export LANG="en_US.UTF-8"

#cd /docker/bertie-uima
#
#mvn package

#
# Install font
#
mkdir -p /usr/local/lib/python2.7/dist-packages/fpdf/font
cp /usr/share/fonts/truetype/droid/DroidSansFallbackFull.ttf /usr/local/lib/python2.7/dist-packages/fpdf/font/

#
# Install web app
#
cd /docker/roche-website

# Install requirements
pip install -r requirements.txt

# Sync database and migrate
python manage.py syncdb --noinput
python manage.py migrate --noinput

# Generate L18N
python manage.py compilemessages

export DJANGO_SETTINGS_MODULE=roche.settings

# Load XML documents into exist and build the fulltext index
#python roche/scripts/xml-load.py
# DONE LATER

python manage.py existdb load-index

# TODO: seems to hang on server
#python manage.py existdb reindex

# Serve the Django WSGI application
rm /var/run/apache2/apache2.pid
/etc/init.d/apache2 start

tail -f /var/log/apache2/error.log
