#!/bin/bash

TITAN_VERSION=$1

git clone https://github.com/thinkaurelius/titan.git && cd titan/
git checkout tags/$TITAN_VERSION

MVN_OPTS="-DskipTests"

if [ "$TITAN_VERSION" == "0.3.2" ]; then
  # Restore <root>/bin/ helper scripts
  git cherry-pick 7bf88ffaf2c5cc4873b08b70ead2849a93a4b2ee
else
  if [ "$TITAN_VERSION" == "`echo -e "$TITAN_VERSION\n0.5.0" | sort -rV | head -n1`" ]; then
    MVN_OPTS="$MVN_OPTS -Ddev.hadoop=1"
    BASE_VERSION=`echo $TITAN_VERSION | awk -F '-' '{print $1}'`
    MILESTONE=`echo $TITAN_VERSION | awk -F '-' '{print $2}'`
    if [ "$BASE_VERSION" == "0.5.0" -a "$MILESTONE" != "" ]; then
      # Add -Ddev.titan=1|2 maven option
      git cherry-pick 5306e9eb78ef573c7d87327d9cef33775efb3873
    fi
  fi
fi

mvn clean package $MVN_OPTS

rm -f conf/core-site.xml conf/mapred-site.xml
cd ../ && mv titan /usr/local/titan-$TITAN_VERSION
ln -sf /usr/local/titan-$TITAN_VERSION /usr/local/titan
