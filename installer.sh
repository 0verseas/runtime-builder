#!/bin/bash

sudo apt update

# install nginx
sudo apt install -y nginx

#install PHP without apache
sudo apt install -y php-cli php-common php-fpm php-curl php-mysql php-xml php-readline php-tidy php-json php-mbstring php-gd php-opcache php-zip php-pear php-bcmath php-tokenizer unzip

#if $HOME/bin dir not exist, then create it
if [ ! -d "$HOME/bin" ] ; then
    mkdir $HOME/bin
fi

#install composer
EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --install-dir=$HOME/bin --filename=composer
php -r "unlink('composer-setup.php');"

sudo chmod +x $HOME/bin/composer

# install mariadb
sudo apt install -y mariadb-server

# install ghostscript
sudo apt install -y  ghostscript

# install fail2ban
sudo apt install -y fail2ban

# install portsentry
sudo apt install -y portsentry

# install supervisor
sudo apt install -y supervisor

# install rsync
sudo apt install -y rsync

# install git
sudo apt install -y git

# install docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
