#!/bin/bash
#######################################
# Let us Setup Apache2 for Ubuntu 16.04
#######################################

# Install Apache2
sudo apt-get update
sudo apt-get install -y --force-yes apache2

# Copy our virtual host template to sites-enabled overwriting the default site conf
sudo cp $TRAVIS_BUILD_DIR/travisCI/defaultsite.conf /etc/apache2/sites-available/000-default.conf

# Copy basic testing files into /var/www
sudo cp $TRAVIS_BUILD_DIR/travisCI/apache.php /var/www/apache.php

# Enable mod rewrite module
sudo a2enmod rewrite

# Enable Default Site
sudo a2ensite 000-default.conf

# Set ServerName Globally
sudo cp $TRAVIS_BUILD_DIR/travisCI/servername.conf /etc/apache2/conf-available/servername.conf

# Add testing of Apache Bad Bot Blocker
sudo mkdir /etc/apache2/custom.d
cd /etc/apache2/custom.d
sudo wget https://raw.githubusercontent.com/mitchellkrogza/apache-ultimate-bad-bot-blocker/master/custom.d/globalblacklist.conf
sudo wget https://raw.githubusercontent.com/mitchellkrogza/apache-ultimate-bad-bot-blocker/master/custom.d/whitelist-ips.conf
sudo wget https://raw.githubusercontent.com/mitchellkrogza/apache-ultimate-bad-bot-blocker/master/custom.d/whitelist-domains.conf
sudo wget https://raw.githubusercontent.com/mitchellkrogza/apache-ultimate-bad-bot-blocker/master/custom.d/blacklist-ips.conf
sudo wget https://raw.githubusercontent.com/mitchellkrogza/apache-ultimate-bad-bot-blocker/master/custom.d/bad-referrer-words.conf
sudo wget https://raw.githubusercontent.com/mitchellkrogza/apache-ultimate-bad-bot-blocker/master/custom.d/blacklist-user-agents.conf
sudo a2enconf servername

# Restart Apache
sudo service apache2 restart

# Set all our setup and deploy scripts to be executable
sudo chmod +x $TRAVIS_BUILD_DIR/travisCI/modify-globalblacklist.sh
sudo chmod +x $TRAVIS_BUILD_DIR/travisCI/modify-readme.sh
sudo chmod +x $TRAVIS_BUILD_DIR/travisCI/deploy-package.sh
sudo chmod +x $TRAVIS_BUILD_DIR/travisCI/modify-files-and-commit.sh