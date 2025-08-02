#!/bin/bash
set -e
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

mkdir java-app
cd java-app
cat <<EOF > Demo.java
import java.util.Scanner;
public class Demo{
   public static void main(String [] args){
      Scanner sc=new Scanner(System.in);
      System.out.println("Enter username:");
      String s=sc.nextLine();
      System.out.println(s);
      }
  }
EOF

cat <<EOF > dockerfile
FROM openjdk:17
COPY . /tmp
WORKDIR /tmp
RUN javac Demo.java
CMD ["java","Demo"]
EOF
sudo docker build -t java-d .
username=$(echo "diptesh" | sudo docker run --rm -i java-d | sed -n 2p)
echo "Username from Java app: $username"
sudo docker pull mysql
sudo docker run -d --name mysql-dip -e MYSQL_ROOT_PASSWORD=diptesh1508 mysql
sleep 30
sudo docker exec mysql-dip sh -c "echo \"CREATE DATABASE ${username}; SHOW DATABASES;\" | mysql -u root -pdiptesh1508"
