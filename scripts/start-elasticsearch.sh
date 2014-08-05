#!/bin/bash

ELASTICSEARCH_PID_FILE=/var/run/elasticsearch.pid

if [ -e /usr/local/elasticsearch ]; then

  if [ -f $ELASTICSEARCH_PID_FILE ]; then
    ps -p $(cat $ELASTICSEARCH_PID_FILE) > /dev/null
    if [ $? -ne 0 ]; then
      rm $ELASTICSEARCH_PID_FILE
    fi
  fi

  if [ ! -f $ELASTICSEARCH_PID_FILE ]; then
    # start ElasticSearch
    /usr/local/elasticsearch/bin/elasticsearch -p $ELASTICSEARCH_PID_FILE > /dev/null 2>&1 &
  fi

fi
