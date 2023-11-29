#!/bin/bash
#sudo dnf install epel-release -y
sudo amazon-linux-extras install epel -y
sudo yum install memcached -y
sudo systemctl start memcached
sudo systemctl enable memcached
sudo systemctl status memcached
sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached
sudo yum install firewalld -y
sudo systemctl start firewalld
sudo systemctl enable firewalld

sudo firewall-cmd --add-port=11211/tcp
sudo firewall-cmd --runtime-to-permanent
sudo firewall-cmd --add-port=11111/udp
sudo firewall-cmd --runtime-to-permanent
sudo memcached -p 11211 -U 11111 -u memcached -d
sudo systemctl restart memcached
sudo systemctl status memcached