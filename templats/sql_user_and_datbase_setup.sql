/* create user */

CREATE DATABASE {{MYSQL_DATABASE}} CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE USER {{MYSQL_USER}}@localhost IDENTIFIED BY '{{MYSQL_PASSWORD}}';
GRANT ALL PRIVILEGES ON {{MYSQL_DB}}.* TO {{MYSQL_USER}}@localhost;