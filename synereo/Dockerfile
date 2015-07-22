FROM debian:jessie
MAINTAINER Yuval Adam <yuval@synereo.com>

# Set all the versions and paths
ENV JAVA_VERSION 7u79
ENV JAVA_DEBIAN_VERSION $JAVA_VERSION-2.5.5-1~deb8u1

ENV SCALA_VERSION 2.10.5
ENV SCALA_FILENAME scala-$SCALA_VERSION.deb
ENV SCALA_DEBPATH http://downloads.typesafe.com/scala/$SCALA_VERSION/$SCALA_FILENAME

ENV SBT_VERSION 0.13.8
ENV SBT_JAR https://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/$SBT_VERSION/sbt-launch.jar

ENV STRATEGIES_VERSION master
ENV STRATEGIES_FILENAME $STRATEGIES_VERSION.tar.gz
ENV STRATEGIES_TAR https://github.com/leithaus/strategies/archive/$STRATEGIES_FILENAME

# Install some JDK7 and some dependencies, then cleanup
RUN apt-get update && apt-get install -y \
    wget \
    openjdk-7-jdk="$JAVA_DEBIAN_VERSION" \
    libjansi-java \
    && rm -rf /var/lib/apt/lists/*

# Install Scala
RUN wget -q $SCALA_DEBPATH
RUN dpkg -i $SCALA_FILENAME
RUN rm -f $SCALA_FILENAME

# Install SBT manually
ADD $SBT_JAR /usr/bin/sbt-launch.jar
COPY sbt.sh /usr/bin/sbt
RUN chmod u+x /usr/bin/sbt

RUN echo "==> Fetching all sbt jars from Maven repo" && \
    echo "==> This will take a while..." && \
    sbt

# Install Strategies
RUN mkdir /app && cd /app
RUN wget $STRATEGIES_TAR && tar -zxvf $STRATEGIES_FILENAME && cd strategies-master
RUN echo "==> Building strategies" && \
	echo "==> This will take an unreasonable amount of time :/ sorry..." && \
	sbt clean compile
