#! /bin/bash
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'OpenSSH'
sudo ufw enable -y
sudo bash -c "echo Hola Mundo!" > /var/www/html/index.html