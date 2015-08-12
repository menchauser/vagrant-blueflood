#!/usr/bin/env bash

# Update repository links
sudo apt-get update

# Set up required environment
sudo apt-get -y -f install curl net-tools
sudo apt-get -y install git
sudo apt-get -y install maven

# Add Cassandra PPA
curl -L http://debian.datastax.com/debian/repo_key | apt-key add -
sudo echo "deb http://debian.datastax.com/community/ stable main" >> /etc/apt/sources.list.d/datastax.list

# Install Python software properties (for apt-add-repository)
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q python-software-properties software-properties-common

# Install Oracle Java 7
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update
sudo echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
sudo apt-get install -y oracle-java7-installer

# Set Oracle Java as default
sudo update-java-alternatives -s java-7-oracle

# Install Cassandra
sudo apt-get install cassandra -y

# Clone BlueFlood repository
git clone http://github.com/rackerlabs/blueflood.git /src/blueflood

# Start Cassandra and BlueFlood
# ???