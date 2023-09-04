FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get -y install apache2 \
	mariadb-server \
	php libapache2-mod-php php-mysql \
	php-mbstring \
	wget xz-utils unzip \
	sqlite3 \
	python3-pip \
	nano less

RUN pip install sqlite3-to-mysql --break-system-packages

RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.tar.xz

RUN rm /var/www/html/index.html
RUN tar --strip-components=1 -xf phpMyAdmin-5.2.1-all-languages.tar.xz -C /var/www/html
RUN mkdir /var/www/html/tmp
RUN chown www-data:www-data /var/www/html/tmp

RUN mkdir /var/run/mysqld
RUN chown mysql:mysql /var/run/mysqld
RUN sed -e 's:^bind-address:#bind-address:g' -i /etc/mysql/mariadb.conf.d/50-server.cnf

RUN wget https://thru.de/fileadmin/SITE_MASTER/content/Dokumente/Downloads/PRTR_Sqlite_Datenbanken/PRTR_20221213_en.zip
RUN unzip PRTR_20221213_en.zip

ADD mprep.sh /mprep.sh
RUN chmod 755 /mprep.sh
RUN /mprep.sh

ADD run.sh /run.sh
RUN chmod 755 /run.sh
CMD ["/run.sh"]

EXPOSE 80
EXPOSE 3306
