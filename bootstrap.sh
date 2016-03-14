#!/usr/bin/env bash
apt-get update
apt-get upgrade
apt-get -f install
apt-get install -y nginx
apt-get install -y mysql-server
apt-get install -y php5-mysql
apt-get install -y php5-fpm
apt-get install -y curl php5-cli git
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

#install node.js
sudo apt-get install -y nodejs

if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi

cd /var/www

if [ ! -d html ]; then
  mkdir html
fi

cd html

git clone https://enhuizhu@bitbucket.org/enhuizhu/eshop.git