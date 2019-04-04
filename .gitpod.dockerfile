FROM gitpod/workspace-full

USER root

RUN apt-get update \
 && apt-get -y install apache2 multitail \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

RUN chown -R gitpod:gitpod /var/run/apache2 /var/lock/apache2 /var/log/apache2 /etc/apache2

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