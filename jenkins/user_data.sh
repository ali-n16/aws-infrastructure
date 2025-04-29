#!/bin/bash

# Exit on any error
set -e

echo "=== Jenkins Installation Script ==="
echo "This script will install Jenkins on Ubuntu 22.04 or newer"

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (use sudo)"
    exit 1
fi

echo "=== Updating System Packages ==="
apt update
apt upgrade -y

echo "=== Installing Adoptium Java 17 ==="
# Add Adoptium repository
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/keyrings/adoptium.asc
echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list

# Install Java 17
apt update
apt install -y temurin-17-jdk

echo "=== Verifying Java Installation ==="
/usr/bin/java --version

echo "=== Installing Jenkins ==="
# Add Jenkins repository key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Add Jenkins repository
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
apt update
apt install -y jenkins

echo "=== Starting Jenkins Service ==="
systemctl start jenkins
systemctl enable jenkins

echo "=== Jenkins Installation Complete ==="
echo "Jenkins service status:"
systemctl status jenkins

# Get the initial admin password
echo -e "\nJenkins initial admin password:"
cat /var/lib/jenkins/secrets/initialAdminPassword

echo -e "\nJenkins is now installed and running!"
echo "Access Jenkins at: http://your_server_ip:8080"
echo "Use the above initial admin password to unlock Jenkins"