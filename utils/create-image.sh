#!/bin/bash

display_usage() {
  echo -e "\nUsage: $0 [-t TITAN-VERSION] [-c CASSANDRA-VERSION] [-e ELASTICSEARCH-VERSION]\n"
}

while getopts ":t:c:e:" opt; do
  case $opt in
    t)
      TITAN_VERSION=$OPTARG
      ;;
    c)
      CASSANDRA_VERSION=$OPTARG
      ;;
    e)
      ELASTICSEARCH_VERSION=$OPTARG
      ;;
    \?)
      display_usage
      exit 1
      ;;
    :)
      display_usage
      exit 1
      ;;
  esac
done

PWD=`pwd`
DIR=$(dirname `readlink -f $0`)

cd $DIR

TITAN_VERSION=`./get-titan-version.sh $TITAN_VERSION`

if [ -z $CASSANDRA_VERSION ]; then
  CASSANDRA_VERSION=`./get-cassandra-version.sh $TITAN_VERSION`
fi

if [ -z $ELASTICSEARCH_VERSION ]; then
  ELASTICSEARCH_VERSION=`./get-elasticsearch-version.sh $TITAN_VERSION`
fi

cd ..
sed -e "s/CASSANDRA_VERSION/$CASSANDRA_VERSION/g" -e "s/TITAN_VERSION/$TITAN_VERSION/g" templates/Dockerfile.tpl > Dockerfile

if [ -z $ELASTICSEARCH_VERSION ]; then
  sed -i '/elasticsearch/d' Dockerfile
else
  sed -i "s/ELASTICSEARCH_VERSION/$ELASTICSEARCH_VERSION/g" Dockerfile
fi

sudo docker build -t titan:$TITAN_VERSION .
rm -f Dockerfile

cd $PWD
