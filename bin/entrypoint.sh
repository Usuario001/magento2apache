#!/bin/bash

### php.ini
[ ! -z "${PHP_MEMORY_LIMIT}" ] && sed -i "s/PHP_MEMORY_LIMIT/${PHP_MEMORY_LIMIT}/" /usr/local/etc/php/php.ini
[ ! -z "${PHP_MAXEXECUTION_TIME}" ] && sed -i "s/PHP_MAXEXECUTION_TIME/${PHP_MAXEXECUTION_TIME}/" /usr/local/etc/php/php.ini
[ ! -z "${PHP_UPLOAD_MAX_FILESIZE}" ] && sed -i "s/PHP_UPLOAD_MAX_FILESIZE/${PHP_UPLOAD_MAX_FILESIZE}/" /usr/local/etc/php/php.ini
[ ! -z "${PHP_POST_MAX_SIZE}" ] && sed -i "s/PHP_POST_MAX_SIZE/${PHP_POST_MAX_SIZE}/" /usr/local/etc/php/php.ini
[ ! -z "${PHP_MAX_IMPUT_VARS}" ] && sed -i "s/PHP_MAX_IMPUT_VARS/${PHP_MAX_IMPUT_VARS}/" /usr/local/etc/php/php.ini
[ ! -z "${PHP_DISPLAY_ERRORS}" ] && sed -i "s/PHP_DISPLAY_ERRORS/${PHP_DISPLAY_ERRORS}/" /usr/local/etc/php/php.ini

### supervisord
[ ! -z "${MAGENTO_USER}" ] && sed -i "s/MAGENTO_USER/${MAGENTO_USER}/" /etc/supervisord.conf
export PATH=$PATH:/var/www/html/bin
chown -R $MAGENTO_USER:$WEBSERVER_USER /var/www/html
chown -R $MAGENTO_USER:root /home/$MAGENTO_USER
