#!/bin/bash

# Variable Declaration
URL='https://www.tooplate.com/zip-templates/2130_waso_strategy.zip'
ART_NAME='2130_waso_strategy'
TEMPDIR="/tmp/webfiles"

echo "Running Setup on Ubuntu"

# Installing Dependencies
echo "########################################"
echo "Installing packages."
echo "########################################"
sudo apt update
sudo apt install apache2 wget unzip -y
echo

# Start & Enable Service
echo "########################################"
echo "Start & Enable Apache2 Service"
echo "########################################"
sudo systemctl start apache2
sudo systemctl enable apache2
echo

# Creating Temp Directory
echo "########################################"
echo "Starting Artifact Deployment"
echo "########################################"
mkdir -p $TEMPDIR
cd $TEMPDIR
echo

wget $URL
unzip $ART_NAME.zip
sudo cp -r $ART_NAME/* /var/www/html/
echo

# Bounce Service
echo "########################################"
echo "Restarting Apache2 service"
echo "########################################"
sudo systemctl restart apache2
echo

# Clean Up
echo "########################################"
echo "Removing Temporary Files"
echo "########################################"
rm -rf $TEMPDIR
echo

sudo systemctl status apache2
ls /var/www/html/
