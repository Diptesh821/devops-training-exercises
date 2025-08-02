#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install apache2 -y
sudo ufw allow "Apache"
sudo ufw enable -y
sudo ufw status
sudo apt install mariadb-server mariadb-client -y
sudo apt install php libapache2-mod-php php-mysql -y
sudo apt install php-cli php-json php-common php-mbstring php-gd php-curl php-xml php-zip -y
sudo systemctl restart apache2
PHP_FILE="/var/www/html/info.php"
cat <<EOF > "$PHP_FILE"
<?php
phpinfo();
?>
EOF

echo "CLOUD-INIT-FINISHED: LAMP components installed" >> /var/log/cloud-init-output.log

