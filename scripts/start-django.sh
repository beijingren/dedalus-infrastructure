#!/bin/bash
#
# Django WSGI application
#
#

# Get the web application
git clone https://github.com/beijingren/roche-website.git /root/roche-website

# Get the config files
git clone https://github.com/beijingren/dedalus-infrastructure.git /root/dedalus-infrastructure

# Install apache WSGI config
cp /root/dedalus-infrastructure/configs/apache2/000-default.conf /etc/apache2/sites-available/
cat /root/dedalus-infrastructure/configs/apache2/apache2.conf >> /etc/apache2/apache2.conf

# Serve the Django WSGI application
/etc/init.d/apache2 start

tail -f /var/log/apache2/error.log
