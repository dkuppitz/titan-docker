#!/bin/bash

TITAN_VERSION=$1

if [ -z $CASSANDRA_VERSION ]; then
  TITAN_VERSION=`./get-titan-version.sh $TITAN_VERSION`
  CASSANDRA_VERSION=`curl -s https://raw.githubusercontent.com/thinkaurelius/titan/$TITAN_VERSION/pom.xml | grep -Po '(?<=<cassandra.version>).*(?=</cassandra.version>)'`
  if [ -z $CASSANDRA_VERSION ]; then
    CASSANDRA_VERSION=`curl -s https://raw.githubusercontent.com/thinkaurelius/titan/$TITAN_VERSION/titan-cassandra/pom.xml | grep -A1 '<artifactId>cassandra-all</artifactId>' | grep -Po '(?<=<version>).*(?=</version>)'`
  fi
fi

echo $CASSANDRA_VERSION
