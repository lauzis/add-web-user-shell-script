#!/bin/bash
# author: Aivars Lauzis
# email: lauzis@inbox.lv



CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SETTINGS_FILE=$CURR_DIR"/settings.cfg";

#include settings
#checks if settings file exists if not exits
if [ -f "$SETTINGS_FILE" ]
then
	source $SETTINGS_FILE
else
	echo ERR:1 Settings file $SETTINGS_FILE not found... sorry, can not continue...
	exit
fi




#todo check if all necassary toolas are there
#todo do we have openssl
#todo do we have mkpasswd
#todo ask for ussername
#todo ask for domain string
#todo try to install ncassary packages
#todo install sudo apt-get install whois
#todo install sudo apt-get install openssl
#todo check if script is in sudo mode


#setting the username and php user name
#todo from input not hardcoded
NEW_USER_NAME="uwp"


MYSQL_USER_NAME=$NEW_USER_NAME


#should check if such user
useradd $NEW_USER_NAME

#generates new password
#todo lenght from config/input not hardcoded
NEW_USER_PASS="$(openssl rand -base64 20)"
#hashes password for updating the user
#todo password hash algorithm from config not hardcoded
NEW_USER_PASS_HASH="$(mkpasswd -m sha-256 $NEW_USER_PASS)"

#changes user passowrd
usermod -p $NEW_USER_PASS_HASH $NEW_USER_NAME

#create home dirs
mkdir /home/$NEW_USER_NAME
mkdir /home/$NEW_USER_NAME/logs
mkdir /home/$NEW_USER_NAME/www

#changes the ownership of the directories
chown $NEW_USER_NAME /home/$NEW_USER_NAME -R
chgrp $NEW_USER_NAME /home/$NEW_USER_NAME -R
chgrp www-data /home/$NEW_USER_NAME/logs -R

CREATE_PHP_USER=0
if [ $CREATE_PHP_USER ]
then
    #creates php user, wihtout password
    PHP_USER_NAME="php_"$NEW_USER_NAME
    groupadd $PHP_USER_NAME
    sudo useradd -g $PHP_USER_NAME $PHP_USER_NAME

fi

#todo copy standart php.conf
#todo copy standart nginx.conf

CREATE_MYSQL_USER_AND_DATABASE=0
if [ $CREATE_MYSQL_USER_AND_DATABASE ]
then
    #generate mysql users passowrd
    MYSQL_USER_PASS="$(openssl rand -base64 20)"

    tmp_file=$CURR_DIR"/templates/tmp.sql"
    yes | cp -rf $CURR_DIR"/templates/sql_user_and_database_setup.sql" $tmp_file
    sed -i -e 's/{{MYSQL_USER}}/'$MYSQL_USER_NAME'/g' $tmp_file
    sed -i -e 's/{{MYSQL_DB}}/'$MYSQL_USER_NAME'/g' $tmp_file
    sed -i -e 's/{{MYSQL_PASSWORD}}/'MYSQL_USER_PASS'/g' $tmp_file

    mysql -u root -p < $tmp_file
    #removes temporary sql file
    rm $tmp_file
fi


echo "U:"$NEW_USER_NAME
echo "P:"$NEW_USER_PASS

if [ $CREATE_MYSQL_USER_AND_DATABASE ]
then
    echo "MYSQL  U:"$NEW_USER_NAME
    echo "MYSQL  O:"$MYSQL_USER_PASS
    echo "MYSQL DB:"$NEW_USER_NAME
fi