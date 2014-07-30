#!/bin/bash

if [ -e /usr/local/hadoop ]; then
  # start Hadoop
  if [ ! -d /tmp/hadoop-root ]; then
    hadoop namenode -format > /dev/null
  fi
  /usr/sbin/sshd && /usr/local/hadoop/bin/start-all.sh
fi
