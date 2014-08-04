#!/bin/bash

HADOOP_VERSION=1.2.1

sed -i 's/required[ ]*pam_loginuid/optional\tpam_loginuid/g' /etc/pam.d/sshd

wget http://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
tar xfz hadoop-$HADOOP_VERSION.tar.gz && rm hadoop-$HADOOP_VERSION.tar.gz
mv hadoop-$HADOOP_VERSION /usr/local/
ln -s /usr/local/hadoop-$HADOOP_VERSION /usr/local/hadoop

cd /usr/local/hadoop
cat > conf/core-site.xml <<EOF
<configuration>
     <property>
         <name>fs.default.name</name>
         <value>hdfs://localhost:9000</value>
     </property>
</configuration>
EOF
cat > conf/hdfs-site.xml <<EOF
<configuration>
     <property>
         <name>dfs.replication</name>
         <value>1</value>
     </property>
</configuration>
EOF
cat > conf/mapred-site.xml <<EOF
<configuration>
     <property>
         <name>mapred.job.tracker</name>
         <value>localhost:9001</value>
     </property>
</configuration>
EOF

sed -i '/return/d' /root/.bashrc
echo -e "\nexport JAVA_HOME=/usr/lib/jvm/java-7-oracle/jre" >> /root/.bashrc
echo "export HADOOP_PREFIX=/usr/local/hadoop" >> /root/.bashrc
echo "export PATH=\$PATH:\$HADOOP_PREFIX/bin" >> /root/.bashrc
