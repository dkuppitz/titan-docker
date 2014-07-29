#!/bin/bash

TITAN_VERSION=$1

git clone https://github.com/thinkaurelius/titan.git && cd titan/
git checkout tags/$TITAN_VERSION

if [ "$TITAN_VERSION" == "0.3.2" ]; then
  # Restore <root>/bin/ helper scripts
  git cherry-pick 7bf88ffaf2c5cc4873b08b70ead2849a93a4b2ee
fi

mvn clean package -DskipTests
cd ../ && mv titan /usr/local/titan-$TITAN_VERSION
ln -sf /usr/local/titan-$TITAN_VERSION /usr/local/titan
