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
    sudo git clone https://github.com/danielcregg/php-login-script.git /var/www/html/login
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

9. Check your /var/www/html folder. Make sure you have an index.php file in there. If you have an index.html file rename it to index.php. If you have both then delete index.html.  

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

18. Install phpMyAdmin – Copy all following code and run 

    ```bash
    sudo mysql -Bse "CREATE DATABASE IF NOT EXISTS auth;CREATE USER IF NOT EXISTS admin@localhost IDENTIFIED BY 'password';GRANT ALL PRIVILEGES ON *.* TO admin@localhost;FLUSH PRIVILEGES;" && 
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" # Select Web Server && 
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true" # Configure database for phpmyadmin with dbconfig-common && 
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password 'password'" # Set MySQL application password for phpmyadmin && 
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password 'password'" # Confirm application password && 
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/internal/skip-preseed boolean true" && 
    DEBIAN_FRONTEND=noninteractive sudo apt -qy install phpmyadmin && 
    printf "\nOpen an internet browser (e.g. Chrome) and go to \e[3;4;33mhttp://$(dig +short myip.opendns.com @resolver1.opendns.com)/phpmyadmin\e[0m - You should see the phpMyAdmin login page. admin/password\n"
    ```

## Resources 

- [Tutorial Republic PHP MySQL Login System](https://www.tutorialrepublic.com/php-tutorial/php-mysql-login-system.php)
- [Digital Ocean How to Install and Secure phpMyAdmin on Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-phpmyadmin-on-ubuntu-18-04)
