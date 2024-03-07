#!/bin/bash

# Create a new DB called auth
sudo mysql -u root -Bse "CREATE DATABASE IF NOT EXISTS auth;"

# Create a new user called admin and grant all privileges
sudo mysql -u root -Bse "CREATE USER IF NOT EXISTS admin@localhost IDENTIFIED BY 'password';GRANT ALL PRIVILEGES ON *.* TO admin@localhost;FLUSH PRIVILEGES;"

# Remove any old login folders
sudo rm -rf /var/www/html/login 

# Download the login code example from GitHub into /var/www/html/login
sudo git clone https://github.com/danielcregg/login-page-php-mysql.git /var/www/html/login

# Create a user's table to store users
sudo mysql -u root auth < /var/www/html/login/database.sql

# Clean up the login folder
sudo rm -rf /var/www/html/login/.git

# Install required PHP module
sudo apt -y install php-mysql

# Restart Apache to pick up changes
sudo service apache2 restart

# Check if /var/www/html/index.php exists
if [ ! -f /var/www/html/index.php ]; then
    # If /var/www/html/index.php doesn't exist, check if /var/www/html/index.html exists
    if [ -f /var/www/html/index.html ]; then
        # If /var/www/html/index.html exists, rename it to /var/www/html/index.php
        mv /var/www/html/index.html /var/www/html/index.php
    else
        echo "Neither /var/www/html/index.php nor /var/www/html/index.html was found."
    fi
else
    # If /var/www/html/index.php exists, check if /var/www/html/index.html exists
    if [ -f /var/www/html/index.html ]; then
        # If /var/www/html/index.html exists, delete it
        rm /var/www/html/index.html
    fi
fi

# Rename index.php to home.php
sudo mv /var/www/html/index.php /var/www/html/home.php

# Add a logout button to the footer of the home.php page
sudo sed -i '/<\/body>/i\    <footer>\n      <a href="logout.php" style="font-size: 18px; color: red; text-decoration: none;">Logout</a>\n    </footer>' /var/www/html/home.php

# Copy contents of login folder to /var/www/html
sudo cp -R /var/www/html/login/* /var/www/html/

# Remove empty login folder
sudo rm -rf /var/www/html/login

# Restart apache to pick up changes
sudo service apache2 restart

# Restart mysql to pick up change to database
sudo service mysql restart

# Install PHPMyAdmin without any prompts
# Select Web Server
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" &&  
# Configure database for phpmyadmin with dbconfig-common
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true" &&
# Set MySQL application password for phpmyadmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password 'password'" &&
# Confirm application password
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password 'password'" &&
# Set a debconf setting for phpmyadmin. This is used to pre-answer a configuration question for the phpmyadmin package.
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/internal/skip-preseed boolean true" && 
# Install phpmyadmin in a non-interactive mode (i.e., without asking any questions during installation).
DEBIAN_FRONTEND=noninteractive sudo apt -qy install phpmyadmin &&
# Print usage instructions to terminal
printf "\nOpen an internet browser (e.g. Chrome) and go to \e[3;4;33mhttp://$(dig +short myip.opendns.com @resolver1.opendns.com)/phpmyadmin\e[0m - You should see the phpMyAdmin login page. admin/password\n"

# Restart apache to pick up changes
sudo service apache2 restart

EOF