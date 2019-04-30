# EnvInits [Gitpod-PHP]

用于 Gitpod 的 Apache + PHP + MySQL + PostgreSQL 环境

An Apache, PHP, MySQL & PostgreSQL environment for Gitpod.


### 尝试一下 / Try it
打开 / Open: https://gitpod.io#https://github.com/teirureddo/envinits-gitpod-php


### 使用方法 / How to use
把 `.gitpod.yml` 和 `.gitpod.dockerfile` 复制到您的项目目录

Copy `.gitpod.yml` and `.gitpod.dockerfile` to your project directory.


### 可用命令 / Available commands
 - apachectl start
 - apachectl stop
 - pg_start.sh
 - pg_stop.sh
 - mysqld --daemonize
 - mysqladmin -uroot shutdown -p
 - gp open /var/log/apache2/error.log
 - gp open /var/log/apache2/access.log
 - gp open ~/pg/log/pgsql.log
 - gp open /var/log/mysql/error.log
 - gp open /var/log/mysql/mysql.log


### 数据库配置 / Database Configuration

**MySQL**
- 服务器 / Server: 0.0.0.0
- 用户 / Username: root
- 密码 / Password: 123456

**PostgreSQL**
- 服务器 / Server: 0.0.0.0
- 用户 / Username: (empty)
- 密码 / Password: (empty)


### 这个项目参考或使用 / Acknowledgement
- gitpod-io/definitely-gp
- gitpod-io/apache-example
- gitpod-io/workspace-images
- meysholdt/laravel-apache-mysql-php-in-gitpod-example