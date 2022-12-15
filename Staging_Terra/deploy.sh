#!/bin/bash
set -x 
sudo apt update
sudo apt -y upgrade
sudo apt -y install python3-pip
pip install --upgrade pip
sudo apt -y install git
sleep 3
git clone -b staging https://github.com/bmol5/Finance-Full-Stack-Web-App-using-Flask-and-SQL.git Finance
sleep 2
cd Finance/
sudo apt-get -y install mysql-server
sudo apt-get -y install libmysqlclient-dev
pip3 install flask-mysqldb
pip install -r requirements.txt
export FLASK_APP=application
USER=${USER}
PASSWORD=${PASSWORD}
ENDPOINT=${PASSWORD}
DATABASE=${DATABASE}
API_KEY=${API_KEY}
DB_URI="mysql://${USER}:${PASSWORD}@${ENDPOINT}/${DATABASE}"
export DB_URI=$${DB_URI}
export API_KEY=$${API_KEY}
flask run --host=0.0.0.0