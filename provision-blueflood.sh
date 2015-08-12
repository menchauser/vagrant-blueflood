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
/vagrant/start-cassandra.sh
sleep 5
/opt/cassandra/bin/cassandra-cli -h 127.0.0.1 -p 9160 -f /src/blueflood/src/cassandra/cli/load.script

# Build BlueFlood
cd /src/blueflood
mvn package -P all-modules

# Install blueflood
cp /src/blueflood/blueflood-all/target/blueflood-all-2.0.0-SNAPSHOT-jar-with-dependencies.jar /src/blueflood/
cp /vagrant/blueflood.conf /src/blueflood/
cp /vagrant/blueflood-log4j.properties /src/blueflood/

# Start BlueFlood
/usr/bin/java \
        -Dblueflood.config=file:blueflood.conf \
        -Dlog4j.configuration=file:blueflood-log4j.properties \
        -Xms1G \
        -Xmx1G \
        -Dcom.sun.management.jmxremote.authenticate=false \
        -Dcom.sun.management.jmxremote.ssl=false \
        -Djava.rmi.server.hostname=127.0.0.1 \
        -Dcom.sun.management.jmxremote.port=9180 \
        -classpath blueflood-all-2.0.0-SNAPSHOT-jar-with-dependencies.jar com.rackspacecloud.blueflood.service.BluefloodServiceStarter

