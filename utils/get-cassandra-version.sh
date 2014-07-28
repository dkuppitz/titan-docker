#!/bin/bash

TITAN_VERSION=$1

if [ -z $CASSANDRA_VERSION ]; then
  TITAN_VERSION=`./get-titan-version.sh $TITAN_VERSION`
  CASSANDRA_VERSION=`curl -s https://raw.githubusercontent.com/thinkaurelius/titan/$TITAN_VERSION/pom.xml | grep -Po '(?<=<cassandra.version>).*(?=</cassandra.version>)'`
fi

echo $CASSANDRA_VERSION
