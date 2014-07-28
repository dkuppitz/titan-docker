#!/bin/bash

TITAN_VERSION=$1

if [ -z "$TITAN_VERSION" -o "$TITAN_VERSION" == "stable" ]; then
  TITAN_VERSION=$(curl -s https://github.com/thinkaurelius/titan/wiki/Release-Notes | grep -Po '(?<=Version )\d+\.\d+\.\d+' | head -n1)
elif [ "$TITAN_VERSION" == "latest" ]; then
  TITAN_VERSION=$(curl -s https://github.com/thinkaurelius/titan | grep 'data-name' | grep -Po '(?<=")\d+\.\d+\.\d+(-[^"]+)?' | head -n1)
fi

echo $TITAN_VERSION
