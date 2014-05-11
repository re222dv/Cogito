#!/bin/bash

set -exv

sh -e /etc/init.d/xvfb start
sudo apt-get update -qq
echo "msttcorefonts msttcorefonts/accepted-mscorefonts-eula boolean true" | sudo debconf-set-selections
sudo apt-get install -qq unzip apache2 wdiff php5-cgi ttf-indic-fonts \
   msttcorefonts ttf-dejavu-core ttf-kochi-gothic ttf-kochi-mincho \
   ttf-thai-tlwg chromium-browser
sudo apt-get install libxss1
