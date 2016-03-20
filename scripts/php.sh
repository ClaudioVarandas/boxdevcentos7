#!/bin/bash

echo ">>> Installing PHP70 FPM"

PHP_TIMEZONE=$1

rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

sudo yum -y install php70w php70w-fpm php70w-opcache php70w-common php70w-gd php70w-mbstring php70w-mcrypt php70w-mysql php70w-pdo php70w-xml


echo ">>> config PHP70 FPM"

# Set PHP FPM to listen on TCP instead of Socket
sudo sed -i "s/listen =.*/listen = 127.0.0.1:9000/" /etc/php-fpm.d/www.conf

# Set PHP FPM allowed clients IP address
sudo sed -i "s/;listen.allowed_clients/listen.allowed_clients/" /etc/php-fpm.d/www.conf

# Set run-as user for PHP-FPM processes to user/group "vagrant"
# to avoid permission errors from apps writing to files
sudo sed -i "s/user = www-data/user = vagrant/" /etc/php-fpm.d/www.conf
sudo sed -i "s/group = www-data/group = vagrant/" /etc/php-fpm.d/www.conf

sudo sed -i "s/listen\.owner.*/listen.owner = vagrant/" /etc/php-fpm.d/www.conf
sudo sed -i "s/listen\.group.*/listen.group = vagrant/" /etc/php-fpm.d/www.conf
sudo sed -i "s/listen\.mode.*/listen.mode = 0666/" /etc/php-fpm.d/www.conf

# PHP Error Reporting Config
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php.ini

# PHP Date Timezone
sudo sed -i "s/;date.timezone =.*/date.timezone = ${PHP_TIMEZONE/\//\\/}/" /etc/php.ini

sudo systemctl restart php-fpm
