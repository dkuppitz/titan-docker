#!/bin/bash

sed -i -e '/docker build/d' -e '/rm -f Dockerfile/d' utils/create-image.sh

utils/create-image.sh -t $1

cat Dockerfile | grep -Po '(?<=^ADD )[^ ]*' > keep.txt
sed -i '/^#/d' Dockerfile

find . -type f -print | grep -v '^\./\.git/' | grep -Pv 'Dockerfile$' | grep -Po '(?<=^\./).*' | grep -Fxvf keep.txt | xargs rm -f
find . -type d -empty | grep -v '^\./\.git/' | xargs rm -rf
