#!/bin/bash

source /root/.bashrc

nohup /usr/sbin/start-hadoop >/dev/null 2>&1&
nohup /usr/sbin/start-cassandra >/dev/null 2>&1&
nohup /usr/sbin/start-elasticsearch >/dev/null 2>&1&

cd /usr/local/titan
bin/gremlin.sh || /bin/bash
