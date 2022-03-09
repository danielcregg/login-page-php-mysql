# php-login-script
This is a simple PHP login script using PHP, PDO, and MySQL

1.	SSH into your LAMP server 
2.	Download my coding example from GitHub to /var/www/html/login (All one command below): 
sudo rm -rf /var/www/html/login;sudo git clone https://github.com/danielcregg/php-login-script.git /var/www/html/login
3.	Create a new DB called auth (All one command below):
sudo mysql -u root -Bse "CREATE DATABASE IF NOT EXISTS auth;CREATE USER IF NOT EXISTS newuser@localhost IDENTIFIED BY 'password';GRANT ALL PRIVILEGES ON auth.* TO newuser@localhost;FLUSH PRIVILEGES;";
4.	Create a user's table to store users:
sudo mysql -u root auth < /var/www/html/login/database.sql
5. Install mysql php module:
sudo apt install php-mysql
6.	Go to browser and open YourIP/login
7.	Merge the contents of your index.php file into the index.php file in the login folder.
8.	Copy the contents of the login folder to your hosted directory and delete the login folder: 
sudo cp -R /var/www/html/login/* /var/www/html/;sudo rm -rf /var/www/html/login
9.	Find YourIP by running the following command in the terminal: 
sudo curl ifconfig.co
10.	Open your webpage in a browser and text your new login page. 
