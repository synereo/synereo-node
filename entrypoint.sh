#!/bin/sh

EVAL_FILE=$W_DIR/splicious/config/eval.conf
LIB_DIR=$W_DIR/splicious/lib
LIBUI_DIR=$W_DIR/splicious/libui

#ENV NODEADMINEMAIL admin@localhost
#ENV NODEADMINPASS a
#DB_HOST=127.0.0.1
#DB_PORT=27017

## Backend
#Node Admin
sed -i 's/nodeAdminEmail = \"admin@localhost\"/nodeAdminEmail = \"'$NODEADMINEMAIL'\"/' $EVAL_FILE
sed -i 's/nodeAdminPass = \"a\"/nodeAdminPass = \"'$NODEADMINPASS'\"/' $EVAL_FILE

#MongdoDB
sed -i 's/dbHost = \"127.0.0.1\"/dbHost = \"'$DB_HOST'\"/' $EVAL_FILE
sed -i 's/dbPort = \"27017\"/dbPort = \"'$DB_PORT'\"/' $EVAL_FILE

#Pull update
if [ "$UBIN" == "1" ]; then
  cd $W_DIR/splicious ; git checkout -f; git pull 
fi
#UBIN = //Update binaries set 1 for update and 0 if not
#AJAR= agentservices-store-ia-1.9.5.jar//Agent store jar
#GJAR= gloseval-0.1.jar //Gloseval jar
#SJAR= specialK-1.1.8.5.jar //SpecialK jar
if [ "$UBKBIN" == "1" ]; then
  wget https://github.com/synereo/compilednode/raw/master/lib/$AJAR -O $LIB_DIR/$AJAR
  wget https://github.com/synereo/compilednode/raw/master/lib/$GJAR -O $LIB_DIR/$GJAR
  wget https://github.com/synereo/compilednode/raw/master/lib/$SJAR -O $LIB_DIR/$SJAR
fi
#UUIBIN= //Update binaries set 1 for update and 0 if not
#UIAJAR=server.server-1.0.1-assets.jar
#UIEJAR=server.server-1.0.1-sans-externalized.jar
#UISJAR=sharedjvm.sharedjvm-0.1-SNAPSHOT.jar
if [ "$UUIBIN" == "1" ]; then
  wget https://github.com/synereo/compilednode/raw/master/libui/$UIAJAR -O $LIBUI_DIR/$UIAJAR
  wget https://github.com/synereo/compilednode/raw/master/libui/$UIEJAR -O $LIBUI_DIR/$UIEJAR
  wget https://github.com/synereo/compilednode/raw/master/libui/$UISJAR -O $LIBUI_DIR/$UISJAR
fi

exec "$@"
