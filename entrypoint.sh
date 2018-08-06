#!/bin/sh
set -e

export ZK_ID=${ZK_ID:-1}

# Set Zookeeper ID
echo $ZK_ID > $ZOOKEEPER_DATA_DIR/myid

# env | grep zk_server
# zk_server.1=172.16.42.101:2888:3888
# zk_server.2=172.16.42.102:2888:3888
# zk_server.3=172.16.42.103:2888:3888

for server in $(env | grep zk_server | sed 's/^zk_//'); do
	echo $server >> $ZOOKEEPER_HOME/conf/zoo.cfg
done

exec "$@"
