#!/bin/sh

EVAL_FILE=$W_DIR/splicious/config/eval.conf
LIB_DIR=$W_DIR/splicious/lib

#ENV NODEADMINEMAIL admin@localhost
#ENV NODEADMINPASS a
#DB_HOST=127.0.0.1
#DB_PORT=27017
#UBIN = //Update binaries set 1 for update and 0 if not
#AJAR= agentservices-store-ia-1.9.5.jar//Agent store jar
#GJAR= gloseval-0.1.jar //Gloseval jar
#SJAR= specialK-1.1.8.5.jar //SpecialK jar

## Backend
#Node Admin
sed -i 's/nodeAdminEmail = \"admin@localhost\"/nodeAdminEmail = \"'$NODEADMINEMAIL'\"/' $EVAL_FILE
sed -i 's/nodeAdminPass = \"a\"/nodeAdminPass = \"'$NODEADMINPASS'\"/' $EVAL_FILE

#MongdoDB
sed -i 's/dbHost = \"127.0.0.1\"/dbHost = \"'$DB_HOST'\"/' $EVAL_FILE
sed -i 's/dbPort = \"27017\"/dbPort = \"'$DB_PORT'\"/' $EVAL_FILE

if [ "$UBIN" == "1" ]; then
  wget https://github.com/synereo/compilednode/raw/master/lib/$GJAR -O $LIB_DIR
  wget https://github.com/synereo/compilednode/raw/master/lib/$AJAR -O $LIB_DIR
  wget https://github.com/synereo/compilednode/raw/master/lib/$SJAR -O $LIB_DIR
fi

exec "$@"
