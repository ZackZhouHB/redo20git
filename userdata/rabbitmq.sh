#!/bin/bash
sudo yum install epel-release -y
sudo amazon-linux-extras install epel -y
sudo yum update -y
sudo yum install wget -y
cd /tmp/
sudo yum install erlang && sudo yum install rabbitmq-server -y
sudo yum install firewalld -y
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo systemctl enable --now rabbitmq-server
sudo firewall-cmd --add-port=5672/tcp
sudo firewall-cmd --runtime-to-permanent
sudo systemctl start rabbitmq-server
sudo systemctl enable rabbitmq-server
sudo systemctl status rabbitmq-server
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator
sudo systemctl restart rabbitmq-server
