#!/bin/bash

CASSANDRA_VERSION=$1

wget https://archive.apache.org/dist/cassandra/$CASSANDRA_VERSION/apache-cassandra-$CASSANDRA_VERSION-bin.tar.gz
tar xfz apache-cassandra-$CASSANDRA_VERSION-bin.tar.gz && rm apache-cassandra-$CASSANDRA_VERSION-bin.tar.gz
sed -i 's/Xss180k/Xss256k/g' apache-cassandra-$CASSANDRA_VERSION/conf/cassandra-env.sh
mv apache-cassandra-$CASSANDRA_VERSION /usr/local/
ln -sf /usr/local/apache-cassandra-$CASSANDRA_VERSION /usr/local/apache-cassandra
