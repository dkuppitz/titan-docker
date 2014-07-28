#!/bin/bash

if [ -z $CASSANDRA_VERSION ]; then
  TITAN_VERSION=`./get-titan-version.sh $1`
  CASSANDRA_VERSION=curl -s https://raw.githubusercontent.com/thinkaurelius/titan/$TITAN_VERSION/pom.xml | grep -Po '(?<=<cassandra.version>).*(?=</cassandra.version>)'
fi

echo $CASSANDRA_VERSION
