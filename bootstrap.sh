export DEBIAN_FRONTEND="noninteractive"
ROOTPW="roowpw"
DBNAME="eshop"

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $ROOTPW"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $ROOTPW"

#functiont to install all the basic softwares
function installSoftwares {
	apt-get install -y mysql-server
	apt-get install -y nginx
	apt-get install -y php5-mysql
	apt-get install -y php5-fpm
	apt-get install -y curl php5-cli git
	curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
	#install node.js
	sudo apt-get install -y nodejs
}

function createDic {
	if ! [ -L /var/www ]; then
	  rm -rf /var/www
	  ln -fs /vagrant /var/www
	fi

	if [ ! -d /var/www/html ]; then
	  mkdir /var/www/html
	fi
}

function generateNginxConf {
	cat /var/www/nginx.conf > /etc/nginx/sites-enabled/default
}

function installEshop {
	#should check if eshop is already exist
	if [ ! -d /var/www/html/eshop ]; then
		#install ssh key
		#copy the ssh key
	        cp  /var/www/id_rsa* /root/.ssh/
		#run ssh agent
		ssh-agent /bin/bash
		#add private key to the agent
		ssh-add /root/.ssh/id_rsa
		
                if [ ! -n "$(grep "^bitbucket.org " ~/.ssh/known_hosts)" ]; then 
		   ssh-keyscan bitbucket.org >> ~/.ssh/known_hosts 2>/dev/null; 
		fi

		git clone ssh://git@bitbucket.org/enhuizhu/eshop.git /var/www/html/eshop
	fi

	#install all the dependencies
	cd /var/www/html/eshop
	composer install
	installDb
}

function installDb {
        ROOTPW="rootpw"
        DBNAME="eshop"
        #install the database
        mysql -uroot -p${ROOTPW} -e "drop database if exists $DBNAME"
        mysql -uroot -p${ROOTPW} -e "create database if not exists $DBNAME"
        mysql -uroot -p${ROOTPW} -e $DBNAME < /var/www/html/eshop/onlineshop.sql
}

installSoftwares 
createDic 
generateNginxConf 
installEshop 

#everythig is done, just restart nginxs
sudo service nginx restart

