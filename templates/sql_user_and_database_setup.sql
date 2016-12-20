/* create database */
CREATE DATABASE IF NOT EXISTS {{MYSQL_DB}} CHARACTER SET utf8 COLLATE utf8_general_ci;

/* create user */
CREATE USER IF NOT EXISTS {{MYSQL_USER}}@localhost IDENTIFIED BY '{{MYSQL_PASSWORD}}';

/* grant access */
GRANT ALL PRIVILEGES ON {{MYSQL_DB}}.* TO {{MYSQL_USER}}@localhost;