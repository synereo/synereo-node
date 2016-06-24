# Set the base image
FROM livelygig/rsd

LABEL description="Node - compiled version" version="0.2.0"
MAINTAINER N<ns68751+n10n@gmail.com>

ENV NODEADMINEMAIL admin@localhost
ENV NODEADMINPASS a
ENV DB_HOST 127.0.0.1
ENV DB_PORT 27017
ENV W_DIR /usr/local

ENV UBIN 0

ENV UBKBIN 0
ENV AJAR agentservices-store-ia-1.9.5.jar
ENV GJAR gloseval-0.1.jar
ENV SJAR specialK-1.1.8.5.jar

ENV UUIBIN 0
ENV UIAJAR server.server-1.0.1-assets.jar
ENV UIEJAR server.server-1.0.1-sans-externalized.jar
ENV UISJAR sharedjvm.sharedjvm-0.1-SNAPSHOT.jar

COPY precompiled.sh $W_DIR/
COPY entrypoint.sh $W_DIR/

RUN \
    cd $W_DIR \
    && chmod 755 $W_DIR/entrypoint.sh \
    && chmod 755 $W_DIR/precompiled.sh \
    && ./precompiled.sh \
#    && ./reducesize.sh
    
WORKDIR $W_DIR
EXPOSE 9876 9000
ENTRYPOINT ["/usr/local/entrypoint.sh"]
CMD [ "/usr/local/splicious/bin/splicious" ]
CMD [ "/usr/local/frontui/bin/frontui" ]
