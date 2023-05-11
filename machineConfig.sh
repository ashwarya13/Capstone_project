#!/bin/sh
apt update -y
snap install terraform --classic
apt -y install ansible
apt -y install awscli
ansible-galaxy collection install amazon.aws
cd ..
pwd
