#!/bin/sh

EVAL_DIR=/usr/local/splicious/config
#ENV NODEADMINEMAIL admin@localhost
#ENV NODEADMINPASS a

#DEPLOYMENT_MODE=colocated
#MONGODB_HOST=127.0.0.1
#MONGODB_PORT=27017
#DSLSERVER=127.0.0.1
#DSLPORT=5672
#BFCLSERVER=127.0.0.1
#BFCLPORT=5672
#DSLEPSSERVER=127.0.0.1
#DSLEPSPORT=5672

#Node Admin
sed -i 's/nodeAdminEmail = \"admin@localhost\"/nodeAdminEmail = \"'$NODEADMINEMAIL'\"/' $EVAL_DIR/eval.conf
sed -i 's/nodeAdminPass = \"a\"/nodeAdminPass = \"'$NODEADMINPASS'\"/' $EVAL_DIR/eval.conf

#MongdoDB
sed -i 's/dbHost = \"127.0.0.1\"/dbHost = \"'$MONGODB_HOST'\"/' $EVAL_DIR/eval.conf
sed -i 's/dbPort = \"27017\"/dbPort = \"'$MONGODB_PORT'\"/' $EVAL_DIR/eval.conf
#DeploymentMode
sed -i 's/deploymentMode = \"colocated\"/deploymentMode = \"'$DEPLOYMENT_MODE'\"/' $EVAL_DIR/eval.conf
#DSLCommLinkServer
sed -i 's/DSLCommLinkServerHost = \"127.0.0.1\"/DSLCommLinkServerHost = \"'$DSLSERVER'\"/' $EVAL_DIR/eval.conf
#sed -i 's/DSLCommLinkServerPort = \"5672\"/DSLCommLinkServerPort = \"'$DSLPORT'\"/' $EVAL_DIR/eval.conf
sed -i 's/DSLCommLinkServerPort = 5672/DSLCommLinkServerPort = \"'$DSLPORT'\"/' $EVAL_DIR/eval.conf
#BFactoryCommLinkServer
sed -i 's/BFactoryCommLinkServerHost = \"127.0.0.1\"/BFactoryCommLinkServerHost = \"'$BFCLSERVER'\"/' $EVAL_DIR/eval.conf
#sed -i 's/BFactoryCommLinkServerPort = \"5672\"/BFactoryCommLinkServerPort = \"'$BFCLPORT'\"/' $EVAL_DIR/eval.conf
sed -i 's/BFactoryCommLinkServerPort = 5672/BFactoryCommLinkServerPort = \"'$BFCLPORT'\"/' $EVAL_DIR/eval.conf
#DSLEvaluatorPreferredSupplier
sed -i 's/DSLEvaluatorPreferredSupplierHost = \"127.0.0.1\"/DSLEvaluatorPreferredSupplierHost = \"'$DSLEPSSERVER'\"/' $EVAL_DIR/eval.conf
#sed -i 's/DSLEvaluatorPreferredSupplierPort = \"5672\"/DSLEvaluatorPreferredSupplierPort = \"'$DSLEPSPORT'\"/' $EVAL_DIR/eval.conf
sed -i 's/DSLEvaluatorPreferredSupplierPort = 5672/DSLEvaluatorPreferredSupplierPort = \"'$DSLEPSPORT'\"/' $EVAL_DIR/eval.conf
exec "$@" 
