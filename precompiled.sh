#! /bin/bash

#W_DIR="/usr/local"
if [ -z "$W_DIR" ]; then
    echo "W_DIR not set, exiting..."
    exit 1
fi

S_DIR=$W_DIR/splicious
mkdir -p $S_DIR/bin $S_DIR/client $S_DIR/config $S_DIR/lib $S_DIR/logs $S_DIR/resources $S_DIR/scripts && \

DOC=0

#if [ ! -d $S_DIR ]; then
if [ -d $S_DIR ]; then
  ls -l
  wget https://github.com/synereo/synereo/releases/download/synereo0.72/synereo0.72.tgz -O - | tar -xzvf - -C $S_DIR --strip-components 1 
  wget https://github.com/LivelyGig/ProductWebUI/releases/download/synereo0.72/synereo0.72.tar.gz -O - | tar -xzvf - -C $S_DIR/client
fi

cd $S_DIR && \

if [ -d $S_DIR/scripts ]; then
  rm -rf $S_DIR/scripts/.svn 
  svn co -N  --force https://github.com/synereo/synereo/branches/staging/agent-service/AgentServices-Store/scripts
  rm -rf $S_DIR/scripts/.svn 
  svn co -N  --force https://github.com/synereo/synereo/branches/staging/gloseval/scripts
  rm -rf $S_DIR/scripts/.svn 
  svn co -N  --force https://github.com/synereo/synereo/branches/staging/specialk/scripts
  rm -rf $S_DIR/scripts/.svn
fi 
\
wget https://raw.githubusercontent.com/synereo/synereo/staging/gloseval/eval.conf -O $S_DIR/config/eval.conf && \
wget https://raw.githubusercontent.com/synereo/synereo/staging/gloseval/log.properties -O $S_DIR/log.properties && \
\
cd $S_DIR && \
ln -fs config/eval.conf eval.conf && \
  \
  if [ 0 -eq $DOC ]; then
    if [ ! -f "$S_DIR/bin/scala" ]; then
      wget https://raw.githubusercontent.com/synereo/dockernode/master/scalabin.tar.gz -O $S_DIR/scalabin.tar.gz
      cd $S_DIR ; tar -xzvf scalabin.tar.gz ; rm -f scalabin.tar.gz
    fi 
    if [ ! -f "$S_DIR/bin/splicious" ]; then
      wget https://raw.githubusercontent.com/synereo/dockernode/master/splicious.sh -O $S_DIR/bin/splicious
    fi 
  fi
cd $W_DIR/ && \
chmod 755 $S_DIR/bin/*

echo "Pre compiled deployer is exiting.......$?"
exit $?
