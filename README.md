# EnvInits [GitPod-PHP]

用于GitPod的Apache + PHP + MySQL + PostgreSQL环境

An Apache, PHP, MySQL & PostgreSQL example for Gitpod.


### 尝试一下 / Try
打开 / Open: https://gitpod.io#https://github.com/teirureddo/envinits-gitpod-php


### 使用方法 / Instructions
把 `.gitpod.yml` 和 `.gitpod.dockerfile` 复制到您的项目目录

Copy `.gitpod.yml` and `.gitpod.dockerfile` to your project directory.


### 可用命令 / Commands
 - apachectl start
 - apachectl stop
 - pg_start.sh
 - pg_stop.sh
 - mysqld &
 - mysqladmin -uroot shutdown -p
 - gp open /var/log/apache2/error.log
 - gp open /var/log/apache2/access.log
 - gp open ~/pg/logs/pgsql.log
 - gp open /var/log/mysql/error.log
 - gp open /var/log/mysql/mysql.log


### 数据库配置 / Database

**MySQL**
- Server: 0.0.0.0
- Username: root
- Password: 123456

**PostgreSQL**
- Server: 0.0.0.0
- Username: (empty)
- Password: (empty)


### 这个项目参考或使用 / Acknowledgement
- gitpod-io/definitely-gp
- gitpod-io/apache-example
- gitpod-io/workspace-images
- meysholdt/laravel-apache-mysql-php-in-gitpod-example