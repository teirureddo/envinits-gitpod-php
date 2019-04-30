FROM gitpod/workspace-full

USER root

RUN apt-get update \
 && apt-get -y install postgresql postgresql-contrib mysql-server mysql-client \
 && apt-get -y install php-fpm php-cli php-bz2 php-bcmath php-gmp php-imap php-shmop php-soap php-xmlrpc php-xsl php-ldap \
 && apt-get -y install php-amqp php-apcu php-imagick php-memcached php-mongodb php-oauth php-redis\
 && apt-get clean && rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/*

RUN mkdir /var/run/mysqld \
 && chown -R gitpod:gitpod /var/run/mysqld /usr/share/mysql /var/lib/mysql /var/log/mysql /etc/mysql

RUN a2enmod rewrite

RUN echo 'worker_processes auto;\n\
pid /var/run/nginx/nginx.pid;\n\
include /etc/nginx/modules-enabled/*.conf;\n\
env NGINX_DOCROOT_IN_REPO;\n\
env GITPOD_REPO_ROOT;\n\
events {\n\
	worker_connections 768;\n\
	multi_accept on;\n\
}\n\
http {\n\
	sendfile on;\n\
	tcp_nopush on;\n\
	tcp_nodelay on;\n\
	keepalive_timeout 65;\n\
	types_hash_max_size 2048;\n\
	include /etc/nginx/mime.types;\n\
	access_log /var/log/nginx/access.log;\n\
	error_log /var/log/nginx/error.log;\n\
	gzip on;\n\
	include /etc/nginx/conf.d/*.conf;\n\
    server {\n\
        set_by_lua $nginx_docroot_in_repo   '"'"'return os.getenv("NGINX_DOCROOT_IN_REPO")'"'"';\n\
        set_by_lua $gitpod_repo_root        '"'"'return os.getenv("GITPOD_REPO_ROOT")'"'"';\n\
        listen         0.0.0.0:8002;\n\
        location / {\n\
            root $gitpod_repo_root/$nginx_docroot_in_repo;\n\
            index index.html index.htm index.php;\n\
        }\n\
    }\n\
}' > /etc/nginx/nginx.conf

RUN echo '[mysqld_safe]\n\
socket		= /var/run/mysqld/mysqld.sock\n\
nice		= 0\n\
[mysqld]\n\
user		= gitpod\n\
pid-file	= /var/run/mysqld/mysqld.pid\n\
socket		= /var/run/mysqld/mysqld.sock\n\
port		= 3306\n\
basedir		= /usr\n\
datadir		= /var/lib/mysql\n\
tmpdir		= /tmp\n\
lc-messages-dir	= /usr/share/mysql\n\
skip-external-locking\n\
bind-address		= 0.0.0.0\n\
key_buffer_size		= 16M\n\
max_allowed_packet	= 16M\n\
thread_stack		= 192K\n\
thread_cache_size   = 8\n\
myisam-recover-options  = BACKUP\n\
query_cache_limit	    = 1M\n\
query_cache_size        = 16M\n\
general_log_file        = /var/log/mysql/mysql.log\n\
general_log             = 1\n\
log_error               = /var/log/mysql/error.log\n\
expire_logs_days	= 10\n\
max_binlog_size     = 100M' > /etc/mysql/my.cnf

USER gitpod
ENV PATH="$PATH:/usr/lib/postgresql/10/bin"
ENV PGDATA="/home/gitpod/pg/data"
RUN mkdir -p ~/pg/data; mkdir -p ~/pg/scripts; mkdir -p ~/pg/log; mkdir -p ~/pg/sockets; initdb -D pg/data/
RUN echo '#!/bin/bash\npg_ctl -D ~/pg/data/ -l ~/pg/log/pgsql.log -o "-k ~/pg/sockets" start' > ~/pg/scripts/pg_start.sh
RUN echo '#!/bin/bash\npg_ctl -D ~/pg/data/ -l ~/pg/log/pgsql.log -o "-k ~/pg/sockets" stop' > ~/pg/scripts/pg_stop.sh
RUN chmod +x ~/pg/scripts/*
ENV PATH="$PATH:$HOME/pg/scripts"

RUN mysqld --daemonize --skip-grant-tables \
    && sleep 3 \
    && ( mysql -uroot -e "USE mysql; UPDATE user SET authentication_string=PASSWORD(\"123456\") WHERE user='root'; UPDATE user SET plugin=\"mysql_native_password\" WHERE user='root'; FLUSH PRIVILEGES;" ) \
    && mysqladmin -uroot -p123456 shutdown;

USER root