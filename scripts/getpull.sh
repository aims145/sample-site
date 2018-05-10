#!/bin/bash 
#  apache config .
cd /var/www/html
echo "New File as well" > sam.html
chown apache:apache -R ./
