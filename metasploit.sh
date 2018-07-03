#!/bin/bash
#
#
#
echo "█▀▄▀█ ▄███▄     ▄▄▄▄▀ ██      ▄▄▄▄▄   █ ▄▄  █    ████▄ ▄█    ▄▄▄▄▀ "
echo "█ █ █ █▀   ▀ ▀▀▀ █    █ █    █     ▀▄ █   █ █    █   █ ██ ▀▀▀ █    "
echo "█ ▄ █ ██▄▄       █    █▄▄█ ▄  ▀▀▀▀▄   █▀▀▀  █    █   █ ██     █    "
echo "█   █ █▄   ▄▀   █     █  █  ▀▄▄▄▄▀    █     ███▄ ▀████ ▐█    █     "
echo "   █  ▀███▀    ▀         █             █        ▀       ▐   ▀      "
echo "  ▀                     █               ▀                          "

echo "This script install Metasploit on UBUNTU(ALL newest VERSION) or Debian(ALL newest versio)"

sudo su

#========== Install oracle and java ======#

add-apt-repository -y ppa:webupd8team/java
apt-get update
apt-get -y install oracle-java8-installer

#========== Install dependencies =========#

apt-get update && apt-get upgrade
apt-get install build-essential libreadline-dev libssl-dev libpq5 libpq-dev libreadline5 libsqlite3-dev libpcap-dev git-core autoconf postgresql pgadmin3 curl zlib1g-dev libxml2-dev libxslt1-dev vncviewer libyaml-dev curl zlib1g-dev

#========== Install RUBYVERSION ==========#

curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
curl -L https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
echo "source ~/.rvm/scripts/rvm" >> ~/.bashrc
source ~/.bashrc
RUBYVERSION=$(wget https://raw.githubusercontent.com/rapid7/metasploit-framework/master/.ruby-version -q -O - )
rvm install $RUBYVERSION
rvm use $RUBYVERSION --default
ruby -v

#========== Install NMAP ===============#

mkdir ~/Development
cd ~/Development
git clone https://github.com/nmap/nmap.git
cd nmap 
./configure
make
sudo make install
make clean

#====== Configuring POSTGRESQL ========#

sudo -s
su postgres
createuser msf -P -S -R -D
createdb -O msf msf
exit
exit

#====== Metasploit FRAMEWORK =========#

cd /opt
sudo git clone https://github.com/rapid7/metasploit-framework.git
sudo chown -R `whoami` /opt/metasploit-framework
cd metasploit-framework

cd metasploit-framework

# If using RVM set the default gem set that is create when you navigate in to the folder

rvm --default use ruby-${RUByVERSION}@metasploit-framework

gem install bundler
bundle install

cd metasploit-framework
sudo bash -c 'for MSF in $(ls msf*); do ln -s /opt/metasploit-framework/$MSF /usr/local/bin/$MSF;done'

#====== Installing ARMITAGE =========#

curl -# -o /tmp/armitage.tgz http://www.fastandeasyhacking.com/download/armitage150813.tgz
sudo tar -xvzf /tmp/armitage.tgz -C /opt
sudo ln -s /opt/armitage/armitage /usr/local/bin/armitage
sudo ln -s /opt/armitage/teamserver /usr/local/bin/teamserver
sudo sh -c "echo java -jar /opt/armitage/armitage.jar \$\* > /opt/armitage/armitage"
sudo perl -pi -e 's/armitage.jar/\/opt\/armitage\/armitage.jar/g' /opt/armitage/teamserver

echo "Now you must create a DATABASE with NANO on /opt/metasploit-framework/config/database.yml in this way:"

echo "production:"
echo "adapter: postgresql"
echo "database: msf"
echo "username: msf"
echo "password:"
echo "host: 127.0.0.1"
echo "port: 5432"
echo "pool: 75"
echo "timeout: 5"
echo
echo "It's clear? (Tape YES, only UPPERCASE):"
read ANSWER


If [ "$ANSWER" = "YES" ] then
	sudo nano /opt/metasploit-framework/config/database.yml
else
	echo "Read before this command..."
	sudo nano /opt/metasploit-framework/config/database.yml
fi

echo "INSTALLATION TERMINATED..."

exit 0
