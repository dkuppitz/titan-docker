#!/bin/bash

if [ -e /usr/local/hadoop ]; then
  # start Hadoop
  if [ ! -d /tmp/hdfs ]; then
    mkdir -p /tmp/hdfs/{namenode,datanode}
    hdfs namenode -format > /dev/null
  fi
  /usr/sbin/sshd
  hadoop-daemon.sh start namenode
  hadoop-daemon.sh start datanode
  yarn-daemon.sh start resourcemanager
  yarn-daemon.sh start nodemanager
  mr-jobhistory-daemon.sh start historyserver
fi
