#!/bin/bash

CASSANDRA_VERSION=$1

wget https://archive.apache.org/dist/cassandra/$CASSANDRA_VERSION/apache-cassandra-$CASSANDRA_VERSION-bin.tar.gz
tar xfz apache-cassandra-$CASSANDRA_VERSION-bin.tar.gz && rm apache-cassandra-$CASSANDRA_VERSION-bin.tar.gz
sed -i -e "s/^listen_address.*/listen_address: /" -e "s/^rpc_address.*/rpc_address: 0.0.0.0/" -e 's/seeds: "127.0.0.1"/seeds: "SEEDS"/g' -e "s/SEEDS/`ifconfig | grep -Po '(?<=inet addr:)[^ ]*' | head -n1`/g" apache-cassandra-$CASSANDRA_VERSION/conf/cassandra.yaml
sed -i 's/Xss180k/Xss256k/g' apache-cassandra-$CASSANDRA_VERSION/conf/cassandra-env.sh
mv apache-cassandra-$CASSANDRA_VERSION /usr/local/
ln -sf /usr/local/apache-cassandra-$CASSANDRA_VERSION /usr/local/apache-cassandra
