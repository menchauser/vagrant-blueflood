#!/usr/bin/env bash

# Update repository links
sudo apt-get update

# Set up required environment
sudo apt-get -y -f install curl net-tools
sudo apt-get -y install git

# Install Python software properties (for apt-add-repository)
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q python-software-properties software-properties-common

# Install Oracle Java 7
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update
sudo echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
sudo apt-get install -y oracle-java7-installer

# Set Oracle Java as default
sudo update-java-alternatives -s java-7-oracle

# Install Maven for BlueFlood
sudo apt-get -y install maven

# Install Cassandra
echo Install Cassandra
wget http://apache-mirror.rbc.ru/pub/apache/cassandra/2.1.8/apache-cassandra-2.1.8-bin.tar.gz
sudo tar xzf apache-cassandra-2.1.8-bin.tar.gz -C /opt
sudo ln -s /opt/apache-cassandra-2.1.8 /opt/cassandra
sudo chown -R vagrant:vagrant /opt/cassandra/

# TODO: ElasticSearch

# Clone BlueFlood repository
echo Download BlueFlood
sudo mkdir /src
sudo chown -R vagrant:vagrant /src/
git clone http://github.com/rackerlabs/blueflood.git /src/blueflood

# Install schema for Cassandra
cd /src/blueflood
# Build BlueFlood
mvn package -P all-modules

#sleep 5
#$CASSANDRA_HOME/bin/cassandra_cli -f ./src/cassandra/cli/load.script -h 127.0.0.1 -p 9160
