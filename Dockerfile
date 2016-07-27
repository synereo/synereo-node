From alpine:edge 
LABEL description="Single version node" version="0.3.0"
MAINTAINER N<ns68751+n10n@gmail.com>

ENV 	NODEADMINEMAIL admin@localhost 
ENV	NODEADMINPASS a 
ENV	DB_HOST 127.0.0.1 
ENV	DB_PORT 27017 
ENV	W_DIR /usr/local 
ENV	UBIN 0 
ENV	UBKBIN 0 
ENV	AJAR agentservices-store-ia-1.9.5.jar 
ENV	GJAR gloseval-0.1.jar 
ENV	SJAR specialK-1.1.8.5.jar 
ENV	UUIBIN 0 
ENV	UIAJAR server.server-1.0.1-assets.jar 
ENV	UIEJAR server.server-1.0.1-sans-externalized.jar 
ENV	UISJAR sharedjvm.sharedjvm-0.1-SNAPSHOT.jar 
ENV	PYTHON_VERSION=2.7.12-r0 
ENV	PY_PIP_VERSION=8.1.2-r0 
ENV	SUPERVISOR_VERSION=3.3.0 
ENV	RABBITMQ_VERSION=3.6.1 
ENV     RABBITMQ_AUTOCLUSTER_PLUGIN_VERSION=0.4.1 
ENV     RABBITMQ_HOME=/srv/rabbitmq_server-${RABBITMQ_VERSION} 
ENV     PLUGINS_DIR=/srv/rabbitmq_server-${RABBITMQ_VERSION}/plugins 
ENV     ENABLED_PLUGINS_FILE=/srv/rabbitmq_server-${RABBITMQ_VERSION}/etc/rabbitmq/enabled_plugins 
ENV     RABBITMQ_MNESIA_BASE=/var/lib/rabbitmq 
ENV     PATH=$PATH:$RABBITMQ_HOME/sbin

ADD https://raw.githubusercontent.com/mvertes/dosu/0.1.0/dosu /sbin/

#TO BE REMOVED
#COPY entrypoint.sh.rsd $W_DIR/entrypoint.sh
#COPY deploy.sh $W_DIR/deploy.sh

COPY 	sources/livelygigSupervisord.conf /etc/supervisord.conf 
COPY    sources/ssl.config /srv/rabbitmq_server-${RABBITMQ_VERSION}/etc/rabbitmq/
COPY    sources/standard.config /srv/rabbitmq_server-${RABBITMQ_VERSION}/etc/rabbitmq/
COPY    sources/wrapper.sh /usr/bin/wrapper

# Install OpenJDK 8, Maven, SBT, NodeJS and other software
RUN \
    chmod +x /sbin/dosu && \
    echo http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
    echo http://dl-4.alpinelinux.org/alpine/v3.4/main >> /etc/apk/repositories && \
    echo http://dl-4.alpinelinux.org/alpine/v3.4/community>> /etc/apk/repositories && \
    apk add --no-cache mongodb && \
    apk --update add bash git nodejs openjdk8 openssh-client subversion curl && \
    apk add ca-certificates wget && update-ca-certificates && \
    apk add -u -u python=$PYTHON_VERSION py-pip=$PY_PIP_VERSION && \
    pip install supervisor==$SUPERVISOR_VERSION && \
    curl -L http://apache.claz.org/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz -o \
         /usr/lib/apache-maven-3.3.9-bin.tar.gz && \
    curl -L https://dl.bintray.com/sbt/native-packages/sbt/0.13.11/sbt-0.13.11.tgz -o \
         /usr/lib/sbt-0.13.11.tgz && \
    cd /usr/lib/ && \
    tar -xzvf apache-maven-3.3.9-bin.tar.gz && \
    tar -xzvf sbt-0.13.11.tgz && \
    cd /usr/bin && \
    ln -s ../lib/jvm/java-1.8-openjdk/bin/javac /usr/bin/javac && \
    ln -s ../lib/jvm/java-1.8-openjdk/bin/jar /usr/bin/jar && \
    ln -s ../lib/apache-maven-3.3.9/bin/mvn /usr/bin/mvn && \
    ln -s ../lib/sbt/bin/sbt /usr/bin/sbt && \
    rm -rf /var/cache/apk/* /usr/lib/apache-maven-3.3.9-bin.tar.gz /usr/lib/sbt-0.13.11.tgz && \
    chmod a+x /usr/bin/wrapper && apk add --update curl tar xz bash && \
    echo "http://dl-4.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add erlang erlang erlang-mnesia erlang-public-key erlang-crypto erlang-ssl \
            erlang-sasl erlang-asn1 erlang-inets erlang-os-mon erlang-xmerl erlang-eldap \
            erlang-syntax-tools --update-cache --allow-untrusted && \
    cd /srv && \
       rmq_zip_url=https://github.com/rabbitmq/rabbitmq-server/releases/download && \
       rmq_zip_url=${rmq_zip_url}/rabbitmq_v$(echo $RABBITMQ_VERSION | tr '.' '_') && \
       rmq_zip_url=${rmq_zip_url}/rabbitmq-server-generic-unix-${RABBITMQ_VERSION}.tar.xz && \
    curl -Lv -o /srv/rmq.tar.xz $rmq_zip_url && \
    tar -xvf rmq.tar.xz && rm -f rmq.tar.xz && \
    touch /srv/rabbitmq_server-${RABBITMQ_VERSION}/etc/rabbitmq/enabled_plugins && \
    rabbitmq-plugins enable --offline rabbitmq_management && \
    rmq_ac_url=https://github.com/aweber/rabbitmq-autocluster/releases/download && \
    rmq_ac_url=${rmq_ac_url}/${RABBITMQ_AUTOCLUSTER_PLUGIN_VERSION} && \
    rmq_ac_url=${rmq_ac_url}/autocluster-${RABBITMQ_AUTOCLUSTER_PLUGIN_VERSION}.ez && \
    curl -Lv -o ${PLUGINS_DIR}/autocluster-${RABBITMQ_AUTOCLUSTER_PLUGIN_VERSION}.ez $rmq_ac_url && \
    apk del --purge tar xz && rm -Rf /var/cache/apk/* && \
    ln -sf $RABBITMQ_HOME /rabbitmq && \
    cd $W_DIR && \
    curl -L https://github.com/n10n/DockerNode/raw/master/entrypoint.sh.precompiled -o $W_DIR/entrypoint.sh \
    && curl -L https://github.com/n10n/DockerNode/raw/precompiled/precompiled.sh -o $W_DIR/precompiled.sh \
    && chmod 755 $W_DIR/entrypoint.sh $W_DIR/precompiled.sh \
    && ./precompiled.sh 
    #&& ./reducesize.sh #TO BE REMOVED

WORKDIR $W_DIR

VOLUME /data/db 
VOLUME /var/lib/rabbitmq

EXPOSE 9876 9000 27017 28017 5671 5672 15672 15671

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]

