FROM debian:jessie
MAINTAINER Yuval Adam <yuval@synereo.com>

ENV JAVA_VERSION 7u79
ENV JAVA_DEBIAN_VERSION $JAVA_VERSION-2.5.5-1~deb8u1

ENV SCALA_VERSION 2.10.5
ENV SCALA_FILENAME scala-$SCALA_VERSION.deb
ENV SCALA_DEBPATH http://downloads.typesafe.com/scala/$SCALA_VERSION/$SCALA_FILENAME

RUN apt-get update && apt-get install -y \
	wget \
	openjdk-7-jdk="$JAVA_DEBIAN_VERSION" \
	libjansi-java

RUN wget -q $SCALA_DEBPATH
RUN dpkg -i $SCALA_FILENAME
RUN rm -f $SCALA_FILENAME

RUN echo "deb http://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN apt-get update && apt-get install -y --force-yes sbt && rm -rf /var/lib/apt/lists/*
