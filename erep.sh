#!/bin/sh

EVAL_FILE=/opt/docker/eval.conf

if [ ! -d $ENAME ]; then
  sed -i 's/EmailAuthUsername = \"juliatest38\"/EmailAuthUsername = \"'$ENAME'\"/' $EVAL_FILE
fi 

if [ ! -d $EPASS ]; then
  sed -i 's/EmailAuthPassword = \"juliatestjuliatest\"/EmailAuthPassword = \"'$EPASS'\"/' $EVAL_FILE
fi

if [ ! -d $EADDR ]; then
  sed -i 's/EmailFromAddress = \"juliatest38@gmail.com\"/EmailFromAddress = \"'$EADDR'\"/' $EVAL_FILE
fi
