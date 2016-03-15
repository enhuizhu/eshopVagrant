export DEBIAN_FRONTEND="noninteractive"

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password rootpw"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password rootpw"

sudo apt-get install -y mysql-server

apt-get install -y nginx
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

#install ssh key
#copy the ssh key
sudo cp  /var/www/id_rsa* /root/.ssh/
#run ssh agent
sudo ssh-agent /bin/bash
#sudo eval `ssh-agent -s`
#add private key to the agent
sudo ssh-add ~/.ssh/id_rsa

sudo git clone https://enhuizhu@bitbucket.org/enhuizhu/eshop.git /var/www/html/eshop
