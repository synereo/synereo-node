#!/bin/sh

EVAL_FILE=$W_DIR/splicious/config/eval.conf

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

exec "$@"
