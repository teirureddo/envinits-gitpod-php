FROM gitpod/workspace-full

USER root

RUN apt-get update \
 && apt-get -y install apache2 multitail postgresql postgresql-contrib \
 && apt-get clean && rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/*

RUN chown -R gitpod:gitpod /var/run/apache2 /var/lock/apache2 /var/log/apache2 /etc/apache2

#Setup Apache
RUN echo 'ServerRoot ${GITPOD_REPO_ROOT}\n\
PidFile /var/run/apache2/apache.pid\n\
User gitpod\n\
Group gitpod\n\
IncludeOptional /etc/apache2/mods-enabled/*.load\n\
IncludeOptional /etc/apache2/mods-enabled/*.conf\n\
ServerName localhost\n\
Listen *:8000\n\
LogFormat "%h %l %u %t \"%r\" %>s %b" common\n\
CustomLog /var/log/apache2/access.log common\n\
ErrorLog /var/log/apache2/error.log\n\
<Directory />\n\
    AllowOverride None\n\
    Require all denied\n\
</Directory>\n\
DirectoryIndex index.php index.html\n\
DocumentRoot "${GITPOD_REPO_ROOT}/public"\n\
<Directory "${GITPOD_REPO_ROOT}/public">\n\
    Require all granted\n\
</Directory>\n\
IncludeOptional /etc/apache2/conf-enabled/*.conf' > /etc/apache2/apache2.conf

#Setup Postgres
USER gitpod
ENV PATH="$PATH:/usr/lib/postgresql/10/bin"
ENV PGDATA="/home/gitpod/pg/data"
RUN mkdir -p ~/pg/data; mkdir -p ~/pg/scripts; mkdir -p ~/pg/logs; mkdir -p ~/pg/sockets; initdb -D pg/data/
RUN echo '#!/bin/bash\npg_ctl -D ~/pg/data/ -l ~/pg/logs/log -o "-k ~/pg/sockets" start' > ~/pg/scripts/pg_start.sh
RUN echo '#!/bin/bash\npg_ctl -D ~/pg/data/ -l ~/pg/logs/log -o "-k ~/pg/sockets" stop' > ~/pg/scripts/pg_stop.sh
RUN chmod +x ~/pg/scripts/*
ENV PATH="$PATH:$HOME/pg/scripts"

USER root