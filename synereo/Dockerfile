FROM debian:jessie
MAINTAINER Yuval Adam <yuval@synereo.com>

ENV JAVA_VERSION 7u79
ENV JAVA_DEBIAN_VERSION $JAVA_VERSION-2.5.5-1~deb8u1

ENV SCALA_VERSION 2.10.5
ENV SCALA_TARBALL http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.deb

RUN apt-get update && apt-get install -y openjdk-7-jdk="$JAVA_DEBIAN_VERSION" && rm -rf /var/lib/apt/lists/*
