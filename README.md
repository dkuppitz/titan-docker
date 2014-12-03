Quick Start
========

## Clone this repository

```sh
git clone https://github.com/dkuppitz/titan-docker.git
```

## Symbolic link

Create a symbolic link in ```/usr/local/sbin``` to make the ```titan.sh``` script globally available.

```
sudo ln -s $TITAN_DOCKER_HOME/titan.sh /usr/local/sbin/titan
```

## Start using Titan in a temporary Gremlin REPL

```
$ titan
```

It's really just that. This is temporary Gremlin session / container, meaning when you exit the Gremlin REPL all data is lost. If you want to persist your changes, simply provide a name, for example:

```
$ titan graph_of_the_gods
```

## Choose a Titan version

By default ```titan-docker``` will use the latest **stable** Titan release. If you want to use an older version or a milestone release, you can do so by providing a third parameter, for example:

```
$ titan graph_of_the_gods 0.5.0-M2
$ # to create a temporary container, name it '-'
$ titan - 0.5.0-M2
```

## Choose a different Cassandra/ElasticSearch version

By default ```titan-docker``` will determine and use the recommended version of Cassandra and ElasticSearch for the chosen Titan version. You can override these versions by setting the respective environment variables: ```CASSANDRA_VERSION``` and ```ELASTICSEARCH_VERSION```

Some examples:

```
$ CASSANDRA_VERSION=1.2.13 titan - 0.4.4
$ ELASTICSEARCH_VERSION=1.3.0 titan - 0.5.0-M2
$ CASSANDRA_VERSION=1.2.18 ELASTICSEARCH_VERSION=1.2.3 titan - 0.5.0-M2
```

## Mount a local directory

If you need to access files on your host machine (e.g. for data loading or to store  data for later processing), ```titan-docker``` allows you to mount a local directory:

```
$ TITAN_DOCKER_MOUNT=/mnt/data  titan
```

The directory will be available as ```/mnt``` in your Docker container, thus you can do:

```
gremlin> new File("/mnt/input.txt").eachLine({ def line -> println line })
```

## Working with Elasticsearch

Once you are in a Gremlin REPL, you can start working with Elasticsearch like this:

```
g = TitanFactory.open("conf/titan-cassandra-es.properties")

mgmt = g.getManagementSystem()
text = mgmt.makePropertyKey("text").dataType(String.class).make()
mgmt.buildIndex("vertexByText", Vertex.class).addKey(text).buildMixedIndex("search");
mgmt.commit();

v1 = g.addVertex()
v1.setProperty("text", "jupiter")

v2 = g.addVertex()
v2.setProperty("text", "neptune")

v3 = g.addVertex()
v3.setProperty("text", "pluto")

v4 = g.addVertex()
v4.setProperty("text", "hercules")

g.commit()

g.indexQuery("vertexByText", "v.text:(hercules pluto)").vertices()._().transform { [it.getElement().text, it.getScore()] }
```

The output from the last line will look something like this:

```
==>[pluto, 0.3535533845424652]
==>[hercules, 0.3535533845424652]
```

## A final note

If you start a new Titan version for the first time, ```titan-docker``` will create the Docker image from scratch. This will take a good amount of time, so please be patient!
