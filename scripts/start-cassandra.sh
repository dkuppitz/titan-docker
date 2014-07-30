#!/bin/bash

CASSANDRA_PID_FILE=/var/run/cassandra.pid

if [ -f $CASSANDRA_PID_FILE ]; then
  ps -p $(cat $CASSANDRA_PID_FILE) > /dev/null
  if [ $? -ne 0 ]; then
    rm $CASSANDRA_PID_FILE
  fi
fi

if [ ! -f $CASSANDRA_PID_FILE ]; then
  # start Cassandra
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
