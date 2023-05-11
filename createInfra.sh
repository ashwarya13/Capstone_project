#!/bin/sh
cd Capstone_project
cp demo.pem ~/.ssh/id_rsa
chmod 400 ~/.ssh/id_rsa
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpwn5X7F5TEP/jnIyhkpUlopnsg7dxidQv1mfQU4tL9ZVQtzRnge2eB1BoBPj1igKcmeYdZX3zz+gkBAsakWDYCzdT4QDEaFYzqSS8v8er39bxu3QIfuDi441YrzJQyAzrs4d12aEEA9Lsx0HZiNe+DFNfm441yP02k9n11Evlqt2RO76r1kESvCA/A1s4QcxY3sQ0zOCZUBWFPWnbvEIQ4QBmBpVqO/+p3ZhI9xiARVW02X13M07ScLye3Coj47emDWFo3rZPGa9n9NTRNSBwl4ZGvKP19BtrPl+HdqgCqWWv2c8RnQtnU3Nnl45YKHuJZu/Elus5CSTMuCqo/2V6cQUvdn8L9iMRmiMiypesjhtpF1fnGdII4ZYwI05seu9iVEpYU7t7gxtyxzLPkQlN6PHVswx3rqJcq4itaSpbGPAeBnriMLqePowtII6SStm7etAZST68vbMMpylbeC2xuhNfkf/HU2GkYiEZ+Bx1E1bs05gk1vAdIRbkhEeNclE= root@ip-172-31-90-126" > ~/.ssh/id_rsa.pub
terraform init 
terraform apply --auto-approve
pwd
ansible-playbook createInventory.yml
cd ../kube-ansible/
pwd
ansible-playbook -i hosts kube-dependencies.yml
ansible-playbook -i hosts master-cluster.yml
ansible-playbook -i hosts workers-cluster.yml
ansible masters -i hosts -a "sudo snap install helm --classic"
ansible masters -i hosts -a "helm install ingress-nginx ingress-nginx/ingress-nginx"
ansible masters -i hosts -a "kubectl patch svc ingress-nginx-controller -p '{\"spec\": {\"type\": \"LoadBalancer\", \"externalIPs\":[\"174.129.119.133\"]}}'"
ansible-playbook -i hosts app.yaml
ansible masters -i hosts -a "kubectl get all -o wide"
