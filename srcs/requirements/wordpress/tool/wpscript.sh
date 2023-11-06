#!/bin/bash
#set -eux

sleep 10

cd /var/www/html/wordpress

if [ ! -f wp-config.php ]; then
  wp config create --allow-root \
    --dbname=${SQL_DATABASE} \
    --dbuser=${SQL_USER} \
    --dbpass=${SQL_PASSWORD} \
    --dbhost=mariadb \
    --path='/var/www/html/wordpress' \
    --url=https://${DOMAIN_NAME}

wp core install	--allow-root \
			--path='/var/www/html/wordpress' \
			--url=https://${DOMAIN_NAME} \
			--title=${SITE_TITLE} \
			--admin_user=${ADMIN_USER} \
			--admin_password=${ADMIN_PASSWORD} \
			--admin_email=${ADMIN_EMAIL};

wp user create		--allow-root \
			${USER1_LOGIN} ${USER1_MAIL} \
			--role=author \
			--user_pass=${USER1_PASS} ;

# empty cache
wp cache flush --allow-root

fi

if [ ! -d /run/php ]; then
	mkdir /run/php;
fi

# start the PHP FastCGI Process Manager (FPM) for PHP version 7.3 in the foreground
exec /usr/sbin/php-fpm7.4 -F -R