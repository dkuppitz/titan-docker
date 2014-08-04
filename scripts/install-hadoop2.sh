#!/bin/bash

HADOOP_VERSION=2.2.0

sed -i 's/required[ ]*pam_loginuid/optional\tpam_loginuid/g' /etc/pam.d/sshd

wget http://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
tar xfz hadoop-$HADOOP_VERSION.tar.gz && rm hadoop-$HADOOP_VERSION.tar.gz && ln -s /usr/local/hadoop-$HADOOP_VERSION /usr/local/hadoop
mv hadoop-$HADOOP_VERSION /usr/local/

cd /usr/local/hadoop
ln -rs etc/hadoop conf
cd etc/hadoop

sed -i 's@^export JAVA_HOME=.*@export JAVA_HOME=/usr/lib/jvm/java-7-oracle/jre@g' hadoop-env.sh

cat > core-site.xml << EOF
<configuration>
  <property>
    <name>fs.default.name</name>
    <value>hdfs://localhost:9000</value>
  </property>
</configuration>
EOF

cat > yarn-site.xml << EOF
<configuration>
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
  <property>
    <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
    <value>org.apache.hadoop.mapred.ShuffleHandler</value>
  </property>
</configuration>
EOF

cat > mapred-site.xml << EOF
<configuration>
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
</configuration>
EOF

cat > hdfs-site.xml << EOF
<configuration>
  <property>
    <name>dfs.replication</name>
    <value>1</value>
  </property>
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>file:/tmp/hdfs/namenode</value>
  </property>
  <property>
    <name>dfs.datanode.data.dir</name>
    <value>file:/tmp/hdfs/datanode</value>
  </property>
</configuration>
EOF

sed -i '/return/d' /root/.bashrc
cat >> /root/.bashrc << "EOF"

export JAVA_HOME=/usr/lib/jvm/java-7-oracle/jre
export HADOOP_PREFIX=/usr/local/hadoop
export PATH=$PATH:$HADOOP_PREFIX/bin
export PATH=$PATH:$HADOOP_PREFIX/sbin
export HADOOP_MAPRED_HOME=$HADOOP_PREFIX
export HADOOP_COMMON_HOME=$HADOOP_PREFIX
export HADOOP_HDFS_HOME=$HADOOP_PREFIX
export YARN_HOME=$HADOOP_PREFIX
export USER=`whoami`
EOF

