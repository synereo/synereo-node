#From alpine:edge 
From livelygig/rsd
LABEL description="Single version node" version="0.3.0"
MAINTAINER N<ns68751+n10n@gmail.com>

ENV	W_DIR /usr/local 
ENV	PYTHON_VERSION=2.7.12-r0 
ENV	PY_PIP_VERSION=8.1.2-r0 
ENV	SUPERVISOR_VERSION=3.3.0 
ENV	RABBITMQ_VERSION=3.6.1 
ENV RABBITMQ_AUTOCLUSTER_PLUGIN_VERSION=0.4.1 
ENV RABBITMQ_HOME=/srv/rabbitmq_server-${RABBITMQ_VERSION} 
ENV PLUGINS_DIR=/srv/rabbitmq_server-${RABBITMQ_VERSION}/plugins 
ENV ENABLED_PLUGINS_FILE=/srv/rabbitmq_server-${RABBITMQ_VERSION}/etc/rabbitmq/enabled_plugins 
ENV RABBITMQ_MNESIA_BASE=/var/lib/rabbitmq 
ENV PATH=$PATH:$RABBITMQ_HOME/sbin

RUN \

    curl -L https://raw.githubusercontent.com/synereo/dockernode/single/supervisord.conf -o /etc/supervisord.conf \
## Splicious     
    && cd $W_DIR \
    && curl -sL https://github.com/synereo/dockernode/raw/single/precompiled.sh -o $W_DIR/precompiled.sh \
    && chmod 755 $W_DIR/precompiled.sh \
    && ./precompiled.sh 
    #&& ./reducesize.sh #TO BE REMOVED

WORKDIR $W_DIR

VOLUME /data/db 
VOLUME /var/lib/rabbitmq

EXPOSE 80 443 8567 9678 9876 9000 27017 5671 5672 15672 15671

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
