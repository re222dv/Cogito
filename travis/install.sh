#!/bin/bash

set -exv

sh -e /etc/init.d/xvfb start
sudo apt-get update -qq
sudo apt-get install -qq unzip ttf-kochi-gothic ttf-kochi-mincho
sudo apt-get install libxss1
