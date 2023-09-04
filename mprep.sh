#!/bin/sh

mysqld --user=root &

while ! mysql -uroot -e "show databases;"; do
	sleep 1
done

echo "<?php" >/var/www/html/config.inc.php
echo "\$cfg['Servers'][1]['auth_type'] = 'config';" >>/var/www/html/config.inc.php
echo "\$cfg['Servers'][1]['user'] = 'thru';" >>/var/www/html/config.inc.php
echo "\$cfg['Servers'][1]['password'] = 'thru';" >>/var/www/html/config.inc.php

PW="thru"
echo "CREATE DATABASE thru;" | mysql -u root
echo "CREATE USER 'thru'@'%' IDENTIFIED BY '$PW';" | mysql -u root
echo "GRANT ALL PRIVILEGES ON thru.* TO 'thru'@'%';" | mysql -u root

sqlite3mysql -f prtr_en.db -d thru -u thru --mysql-password thru

echo "ALTER TABLE thru.releases ADD FOREIGN KEY (facility_id) REFERENCES facilities(id);" | mysql -u root
