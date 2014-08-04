FROM ubuntu:14.04

MAINTAINER Daniel Kuppitz

RUN apt-get update
RUN apt-get purge -y openjdk*
RUN apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java7-installer
RUN apt-get install -y curl git maven openssh-server wget
RUN sed -i 's/required[ ]*pam_loginuid/optional\tpam_loginuid/g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd
RUN echo "UserKnownHostsFile /dev/null\nStrictHostKeyChecking no\nLogLevel quiet" >> /etc/ssh/ssh_config
RUN ssh-keygen -t dsa -P '' -f /root/.ssh/id_dsa
RUN cat /root/.ssh/id_dsa.pub >> /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/id_dsa /root/.ssh/authorized_keys
RUN chmod 644 /root/.ssh/id_dsa.pub

#ADD scripts/install-hadoop2.sh /tmp/install-hadoop1.sh
ADD scripts/install-hadoop2.sh /tmp/install-hadoop2.sh
ADD scripts/install-cassandra.sh /tmp/install-cassandra.sh
ADD scripts/install-elasticsearch.sh /tmp/install-elasticsearch.sh
ADD scripts/install-titan.sh /tmp/install-titan.sh
#ADD scripts/start-hadoop1.sh /usr/sbin/start-hadoop1
ADD scripts/start-hadoop2.sh /usr/sbin/start-hadoop2
ADD scripts/start-cassandra.sh /usr/sbin/start-cassandra
ADD scripts/start-elasticsearch.sh /usr/sbin/start-elasticsearch
ADD scripts/gremlin.sh /usr/sbin/gremlin

#RUN /tmp/install-hadoop1.sh
RUN /tmp/install-hadoop2.sh
RUN /tmp/install-cassandra.sh CASSANDRA_VERSION
RUN /tmp/install-elasticsearch.sh ELASTICSEARCH_VERSION
RUN /tmp/install-titan.sh TITAN_VERSION

CMD ["gremlin"]
