#!/bin/bash

ELASTICSEARCH_PID_FILE=/var/run/elasticsearch.pid
CASSANDRA_PID_FILE=/var/run/cassandra.pid

echo

if [ -e /usr/local/elasticsearch ]; then

  if [ -f $ELASTICSEARCH_PID_FILE ]; then
    ps -p $(cat $ELASTICSEARCH_PID_FILE) > /dev/null
    if [ $? -ne 0 ]; then
      rm $ELASTICSEARCH_PID_FILE
    fi
  fi

  if [ ! -f $ELASTICSEARCH_PID_FILE ]; then
    echo "Starting ElasticSearch..."
    /usr/local/elasticsearch/bin/elasticsearch -p $ELASTICSEARCH_PID_FILE > /dev/null 2>&1 &
  fi

fi

if [ -f $CASSANDRA_PID_FILE ]; then
  ps -p $(cat $CASSANDRA_PID_FILE) > /dev/null
  if [ $? -ne 0 ]; then
    rm $CASSANDRA_PID_FILE
  fi
fi

if [ ! -f $CASSANDRA_PID_FILE ]; then
  echo "Starting Cassandra..."
  /usr/local/apache-cassandra/bin/cassandra -p $CASSANDRA_PID_FILE > /dev/null 2>&1 &
  sleep 1
fi

attempts=0

until [ -f /var/log/cassandra/system.log ]
do
    attempts=$((counter+1))
    if [ "$attempts" -gt 30 ]; then
      echo "Failed to start Cassandra within 30 seconds."
      exit 1
    fi
done

until tail /var/log/cassandra/system.log | grep -q "Listening for thrift clients"
do
    attempts=$((counter+1))
    if [ "$attempts" -gt 30 ]; then
      echo "Failed to start Cassandra within 30 seconds."
      exit 1
    fi
    sleep 1
done

echo -e "Starting Gremlin REPL...\n"

cd /usr/local/titan && bin/gremlin.sh
