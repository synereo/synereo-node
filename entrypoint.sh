#!/bin/sh

#MONGODB_HOST=127.0.0.1
#MONGODB_PORT=27017
#DSLSERVER=127.0.0.1
#DSLPORT=5672
#BFCLSERVER=127.0.0.1
#BFCLPORT=5672
#DSLEPSSERVER=127.0.0.1
#DSLEPSPORT=5672

#MongdoDB
sed -i 's/dbHost = \"127.0.0.1\"/dbHost = \"'$MONGODB_HOST'\"/' /usr/local/splicious/eval.conf
sed -i 's/dbPort = \"27017\"/dbPort = \"'$MONGODB_PORT'\"/' /usr/local/splicious/eval.conf
#DSLCommLinkServer
sed -i 's/DSLCommLinkServerHost = \"127.0.0.1\"/DSLCommLinkServerHost = \"'$DSLSERVER'\"/' /usr/local/splicious/eval.conf
#sed -i 's/DSLCommLinkServerPort = \"5672\"/DSLCommLinkServerPort = \"'$DSLPORT'\"/' /usr/local/splicious/eval.conf
sed -i 's/DSLCommLinkServerPort = 5672/DSLCommLinkServerPort = \"'$DSLPORT'\"/' /usr/local/splicious/eval.conf
#BFactoryCommLinkServer
sed -i 's/BFactoryCommLinkServerHost = \"127.0.0.1\"/BFactoryCommLinkServerHost = \"'$BFCLSERVER'\"/' /usr/local/splicious/eval.conf
#sed -i 's/BFactoryCommLinkServerPort = \"5672\"/BFactoryCommLinkServerPort = \"'$BFCLPORT'\"/' /usr/local/splicious/eval.conf
sed -i 's/BFactoryCommLinkServerPort = 5672/BFactoryCommLinkServerPort = \"'$BFCLPORT'\"/' /usr/local/splicious/eval.conf
#DSLEvaluatorPreferredSupplier
sed -i 's/DSLEvaluatorPreferredSupplierHost = \"127.0.0.1\"/DSLEvaluatorPreferredSupplierHost = \"'$DSLEPSSERVER'\"/' /usr/local/splicious/eval.conf
#sed -i 's/DSLEvaluatorPreferredSupplierPort = \"5672\"/DSLEvaluatorPreferredSupplierPort = \"'$DSLEPSPORT'\"/' /usr/local/splicious/eval.conf
sed -i 's/DSLEvaluatorPreferredSupplierPort = 5672/DSLEvaluatorPreferredSupplierPort = \"'$DSLEPSPORT'\"/' /usr/local/splicious/eval.conf
exec "$@" 
