#!/bin/bash
# author: Aivars Lauzis
# email: lauzis@inbox.lv

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
NEW_USER_NAME="dev_uwp"
PHP_USER_NAME="php_"$NEW_USER_NAME;

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

#creates php user, wihtout password
groupadd $PHP_USER_NAMER
sudo useradd -g php_$NEW_USER_NAME php_$NEW_USER_NAME

#todo copy standart php.conf
#todo copy standart nginx.conf


echo "U:"$NEW_USER_NAME
echo "P:"$NEW_USER_PASS
