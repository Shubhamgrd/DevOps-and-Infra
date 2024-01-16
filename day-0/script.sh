#the following script will install docker and docker compose on amazon linux 2

# run this script then 
# sudo docker ps; docker-compose up 
# note docker-compose up doesnt use sudo

sudo yum update -y
sudo yum install docker git -y
sudo usermod -a -G docker ec2-user
id ec2-user
newgrp docker
sudo yum install python3-pip -y
sudo pip3 install docker-compose
sudo systemctl enable docker.service
sudo systemctl start docker.service

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
terraform --version

sudo yum install python3 -y
python3 --version