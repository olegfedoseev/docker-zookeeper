FROM develar/java
MAINTAINER Oleg Fedoseev <oleg.fedoseev@me.com>

ENV ZOOKEEPER_VERSION  3.4.13
ENV ZOOKEEPER_HOME     /usr/local/zookeeper
ENV ZOOKEEPER_DATA_DIR /data/zookeeper
ENV PATH               $PATH:$ZOOKEEPER_HOME/bin:$ZOOKEEPER_HOME/sbin

LABEL name="zookeeper" version=$VERSION

RUN addgroup zookeeper && adduser -G zookeeper -D -H zookeeper
RUN apk add --update curl bash && \
    curl -kL http://apache-mirror.rbc.ru/pub/apache/zookeeper/stable/zookeeper-$ZOOKEEPER_VERSION.tar.gz | tar -zx -C /tmp && \
    mv /tmp/zookeeper-$ZOOKEEPER_VERSION /usr/local/zookeeper && chown -R zookeeper:zookeeper /usr/local/zookeeper && \
    apk del curl && rm -rf /tmp/* /var/cache/apk/* $ZOOKEEPER_HOME/bin/*.cmd $ZOOKEEPER_HOME/dist-maven/ $ZOOKEEPER_HOME/src/ $ZOOKEEPER_HOME/recipes/

ADD conf/zoo.cfg $ZOOKEEPER_HOME/conf/zoo.cfg
ADD conf/log4j.properties $ZOOKEEPER_HOME/conf/log4j.properties
ADD entrypoint.sh $ZOOKEEPER_HOME/bin/entrypoint.sh

VOLUME /data/zookeeper

EXPOSE 2181 2888 3888

ENV JMXDISABLE  true
ENV ZOOCFGDIR   $ZOOKEEPER_HOME/conf
ENV JVMFLAGS    "-Dlog4j.configuration=file:$ZOOKEEPER_HOME/conf/log4j.properties $JVMFLAGS"

ENTRYPOINT ["/usr/local/zookeeper/bin/entrypoint.sh"]
CMD ["/usr/local/zookeeper/bin/zkServer.sh", "start-foreground"]
