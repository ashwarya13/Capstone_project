#!/bin/sh
apt update -y
snap install terraform --classic
apt install ansible
apt install awscli
ansible-galaxy collection install amazon.aws
git clone https://github.com/ashwarya13/Capstone_project.git
git clone https://github.com/ashwarya13/kube-ansible.git

