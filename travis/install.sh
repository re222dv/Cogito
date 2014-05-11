#!/bin/bash

set -exv

sh -e /etc/init.d/xvfb start
sudo apt-get update -qq
sudo apt-get install -qq unzip apache2 wdiff php5-cgi ttf-indic-fonts \
   msttcorefonts ttf-dejavu-core ttf-kochi-gothic ttf-kochi-mincho \
   ttf-thai-tlwg
sudo apt-get install libxss1
