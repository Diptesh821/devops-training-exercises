#!/bin/bash
set -e
# Installing Docker and git
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo apt install -y git

mkdir apache-d
cd apache-d
cat <<EOF > index.html
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Apache</title>
</head>
<body style="text-align:center; margin-top:100px;">
    <h1>Welcome to Apache Web Server!</h1>
    <h2>Deployed by Diptesh Singh</h2>
</body>
</html>
EOF

cat <<EOF > dockerfile
FROM httpd:latest
COPY index.html /usr/local/apache2/htdocs/index.html
EOF

sudo docker build -t apache-d .
sudo docker run -d -p 80:80 --name my-apache apache-d
sudo docker ps
curl -s http://localhost:80
