#!/usr/bin/env bash
sudo yum update -y
sudo yum install -y git curl wget ntp vim htop lynx
sudo yum install -y httpd24 php70 php70-fpm php70-mysqlnd php70-xml php70-curl php70-mcrypt php70-imagick php70-intl php70-gd php70-mbstring php70-zip php70-bcmath
sudo echo "ServerName localhost" > /etc/httpd/conf.d/servername.conf
sudo service httpd start
sudo chkconfig httpd on
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && sudo php composer-setup.php --install-dir=/usr/bin --filename=composer && php -r "unlink('composer-setup.php');"
sudo service mysqld start
sudo mysql_secure_installation
