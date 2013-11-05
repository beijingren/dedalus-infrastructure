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

# Serve the Django WSGI application
/etc/init.d/apache2 start

tail -f /var/log/apache2/error.log
