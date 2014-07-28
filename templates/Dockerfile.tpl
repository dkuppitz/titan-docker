FROM ubuntu:14.04

MAINTAINER Daniel Kuppitz

RUN apt-get update
RUN apt-get purge -y openjdk*
RUN apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java7-installer
RUN apt-get install -y curl git maven wget

ADD scripts/install-cassandra.sh /tmp/install-cassandra.sh
ADD scripts/install-elasticsearch.sh /tmp/install-elasticsearch.sh
ADD scripts/install-titan.sh /tmp/install-titan.sh
ADD scripts/gremlin.sh /usr/sbin/gremlin

RUN /tmp/install-cassandra.sh CASSANDRA_VERSION
RUN /tmp/install-elasticsearch.sh ELASTICSEARCH_VERSION
RUN /tmp/install-titan.sh TITAN_VERSION

CMD ["gremlin"]
