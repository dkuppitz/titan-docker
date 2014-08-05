#!/bin/bash

TITAN_VERSION=$1

if [ -z $ELASTICSEARCH_VERSION ]; then
  TITAN_VERSION=`./get-titan-version.sh $TITAN_VERSION`
  ELASTICSEARCH_VERSION=`curl -s https://raw.githubusercontent.com/thinkaurelius/titan/$TITAN_VERSION/pom.xml | grep -Po '(?<=<elasticsearch.version>).*(?=</elasticsearch.version>)'`
  if [ -z $ELASTICSEARCH_VERSION ]; then
    ELASTICSEARCH_VERSION=`curl -s https://raw.githubusercontent.com/thinkaurelius/titan/$TITAN_VERSION/titan-es/pom.xml | grep -Po '(?<=<elasticsearch.version>).*(?=</elasticsearch.version>)'`
    if [ -z $ELASTICSEARCH_VERSION ]; then
      ELASTICSEARCH_VERSION=`curl -s https://raw.githubusercontent.com/thinkaurelius/titan/$TITAN_VERSION/titan-es/pom.xml | grep -A8 '<artifactId>elasticsearch</artifactId>' | grep -Po '(?<=<version>).*(?=</version>)'`
    fi
  fi
fi

echo $ELASTICSEARCH_VERSION
