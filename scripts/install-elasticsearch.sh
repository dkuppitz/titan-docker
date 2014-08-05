#!/bin/bash

ELASTICSEARCH_VERSION=$1

wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-$ELASTICSEARCH_VERSION.tar.gz
tar xfz elasticsearch-$ELASTICSEARCH_VERSION.tar.gz && rm elasticsearch-$ELASTICSEARCH_VERSION.tar.gz
echo "path.home: /usr/local/elasticsearch-$ELASTICSEARCH_VERSION" >> elasticsearch-$ELASTICSEARCH_VERSION/config/elasticsearch.yml
echo "path.data: /var/lib/elasticsearch" >> elasticsearch-$ELASTICSEARCH_VERSION/config/elasticsearch.yml
echo "path.logs: /var/log/elasticsearch" >> elasticsearch-$ELASTICSEARCH_VERSION/config/elasticsearch.yml
mv elasticsearch-$ELASTICSEARCH_VERSION /usr/local/
ln -sf /usr/local/elasticsearch-$ELASTICSEARCH_VERSION /usr/local/elasticsearch
