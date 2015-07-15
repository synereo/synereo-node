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
