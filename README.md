# Add a Login Page to your website via PHP and MySQL Login System 

1. SSH into your LAMP server. Use the following command, replacing `your_username` and `your_server_ip` with your actual username and server IP address:

    ```bash
    ssh your_username@your_server_ip
    ```

2. Create a new DB called auth. This DB will store the user table. 

   ```bash
   sudo mysql -u root -Bse "CREATE DATABASE IF NOT EXISTS auth;"
   ```

3. Create a new user called admin with password = 'password' and grant admin user all privileges on all DBs.

   ```bash
   sudo mysql -u root -Bse "CREATE USER IF NOT EXISTS admin@localhost IDENTIFIED BY 'password';GRANT ALL PRIVILEGES ON *.* TO admin@localhost;FLUSH PRIVILEGES;"
   ```

4. Remove any old login folders:

    ```bash
    sudo rm -rf /var/www/html/login 
    ```

5. Download the login code example from GitHub into /var/www/html/login:

    ```bash
    sudo git clone https://github.com/danielcregg/login-page-php-mysql.git /var/www/html/login
    ```

6. Create a user's table to store users: 

   ```bash
   sudo mysql -u root auth < /var/www/html/login/database.sql
   ```

7. Install required PHP module:  

   ```bash
   sudo apt -y install php-mysql
   ```

8. Restart Apache to pick up changes: 

   ```bash
   sudo service apache2 restart
   ```

9. Run the following code bloack to check your /var/www/html folder to make sure you have an index.php file in there. If you have an index.html file it will be renamed it to index.php. If you have both then index.html will be deleted.

    ```bash
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
    ```

10. Copy the contents of the login folder to your hosted directory and delete the login folder:  

    ```bash
    sudo mv /var/www/html/index.php /var/www/html/home.php
    ```

11. Add a logout button to the footer of the home.php page 

    ```bash
    sudo sed -i '/<\/body>/i\    <footer>\n      <a href="logout.php" style="font-size: 18px; color: red; text-decoration: none;">Logout</a>\n    </footer>' /var/www/html/home.php
    ```

12. Copy contents of login folder to /var/www/html 

    ```bash
    sudo cp -R /var/www/html/login/* /var/www/html/
    ```

13. Remove empty login folder 

    ```bash
    sudo rm -rf /var/www/html/login
    ```

14. Restart apache to pick up changes. 

    ```bash
    sudo service apache2 restart
    ```

15. Restart mysql to pick up change to database. 

    ```bash
    sudo service mysql restart
    ```

16. Find YourIP by running the following command in the terminal: 

    ```bash
    dig +short myip.opendns.com @resolver1.opendns.com
    ```

17. Open a browser and put your IP in a new tab. You should see a login page. Register and log in. You should get you your home page (your old index.php page).   

18. Install phpMyAdmin without user interaction – Copy all following code as one block and run together 

    ```bash
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
    ```

## Resources 

- [Tutorial Republic PHP MySQL Login System](https://www.tutorialrepublic.com/php-tutorial/php-mysql-login-system.php)
- [Digital Ocean How to Install and Secure phpMyAdmin on Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-phpmyadmin-on-ubuntu-18-04)
