#!/bin/bash

TITAN_VERSION=$1

git clone https://github.com/thinkaurelius/titan.git && cd titan/
git checkout tags/$TITAN_VERSION
mvn clean package -DskipTests
cd ../ && mv titan /usr/local/titan-$TITAN_VERSION
ln -sf /usr/local/titan-$TITAN_VERSION /usr/local/titan
