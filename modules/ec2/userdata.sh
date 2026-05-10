#!/bin/bash

set -x
exec > /var/log/user-data.log 2>&1

yum update -y

yum install -y docker
systemctl start docker
systemctl enable docker

usermod -aG docker ec2-user

yum install -y aws-cli

sleep 10

aws ecr get-login-password --region us-east-1 | \
docker login --username AWS --password-stdin 034255117476.dkr.ecr.us-east-1.amazonaws.com

docker pull 034255117476.dkr.ecr.us-east-1.amazonaws.com/shopflow-app:latest

docker run -d \
  --name shopflow \
  --restart always \
  -p 80:80 \
  034255117476.dkr.ecr.us-east-1.amazonaws.com/shopflow-app:latest