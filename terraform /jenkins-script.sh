#!/bin/bash

# Update the package index to ensure we have the latest list of available packages
apt update -y

# Install fontconfig and OpenJDK 17, both are dependencies required for Jenkins
apt install fontconfig openjdk-17-jre -y
# Download the Jenkins signing key and save it to the system’s trusted keyring
wget -O /usr/share/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
# Add the Jenkins repository to the system’s package sources, referencing the signing key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list > /dev/null
# Update the package index again to include packages from the newly added Jenkins repository
apt-get update -y
# Install Jenkins from the Jenkins repository
apt-get install jenkins -y

# get the password 
while [ ! -f /var/lib/jenkins/secrets/initialAdminPassword ]; do
echo "Waiting for Jenkins to be installed..."
sleep 5
done
echo "Jenkins is installed. Capturing admin password."
cat /var/lib/jenkins/secrets/initialAdminPassword >> /home/ubuntu/jenkins_pwd.txt
echo "Password saved to /home/ubuntu/jenkins_pwd.txt"

# Installing Docker 
#!/bin/bash
sudo apt update
sudo apt install docker.io -y
sudo usermod -aG docker jenkins
sudo usermod -aG docker ubuntu
sudo systemctl restart docker
sudo chmod 777 /var/run/docker.sock

# Installing Trivy
# !/bin/bash
sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update -y
sudo apt-get install trivy -y

# Run Docker Container of Sonarqube server
#!/bin/bash
# docker run -d  --name sonar -p 9000:9000 sonarqube:lts-community

# Check every thing got installed 
jenkins --version
docker --version
docker ps 
trivy --version

echo "All Set"