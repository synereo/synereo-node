#! /bin/bash

findAppHome () {
  local source="${BASH_SOURCE[0]}"
  while [ -h "$source" ] ; do
    local linked="$(readlink "$source")"
    local dir="$( cd -P $(dirname "$source") && cd -P $(dirname "$linked") && pwd )"
    source="$dir/$(basename "$linked")"
  done
  ( cd -P "$(dirname "$source")/" && pwd )
}

echo "Running from directory: $(findAppHome)"

#W_DIR="/usr/local"
if [ -z "$W_DIR" ]; then
    echo "W_DIR not set and setting up to $(findAppHome)"
    #exit 1
    W_DIR="$(findAppHome)"
fi

#B_TAR=https://github.com/synereo/synereo/releases/download/synereo0.72btc/synereo0.72btc.tgz
B_TAR=https://github.com/synereo/synereo/releases/download/synereo0.73amp/synereo073amp.tgz
#U_TAR=https://github.com/LivelyGig/ProductWebUI/releases/download/synereo0.72btc/synereo0.72btc.tar.gz
U_TAR=https://github.com/LivelyGig/ProductWebUI/releases/download/synereo0.73amp/ui0.73amp.tar.gz

S_DIR=$W_DIR/splicious
mkdir -p $S_DIR/client $S_DIR/config $S_DIR/logs $S_DIR/resources $S_DIR/scripts && \

DOC=0

#if [ ! -d $S_DIR ]; then
if [ -d $S_DIR ]; then
  wget $B_TAR -O - | tar -xzvf - -C $S_DIR/scripts 
  mv $S_DIR/scripts/gloseval-2.0-*/bin $S_DIR/scripts/gloseval-2.0-*/lib $S_DIR/
  rm -rf $S_DIR/scripts/gloseval-2.0-*
  wget $U_TAR -O - | tar -xzvf - -C $S_DIR/client
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
wget https://github.com/synereo/synereo/releases/download/synereo0.73amp/eval.conf -O $S_DIR/config/eval.conf && \
#wget https://raw.githubusercontent.com/synereo/synereo/staging/gloseval/eval.conf -O $S_DIR/config/eval.conf && \
wget https://raw.githubusercontent.com/synereo/synereo/staging/gloseval/log.properties -O $S_DIR/log.properties && \
\
cd $S_DIR && \
ln -fs config/eval.conf eval.conf && \
  \
  if [ 0 -eq $DOC ]; then
    if [ ! -f "$S_DIR/bin/scala" ]; then
#      wget https://raw.githubusercontent.com/synereo/dockernode/master/scalabin.tar.gz -O $S_DIR/scalabin.tar.gz
#      cd $S_DIR ; tar -xzvf scalabin.tar.gz ; rm -f scalabin.tar.gz
      wget https://raw.githubusercontent.com/synereo/dockernode/master/scalabin.tar.gz -O - |tar -xzvf - -C $S_DIR/
    fi 
    if [ ! -f "$S_DIR/bin/splicious" ]; then
      wget https://raw.githubusercontent.com/synereo/dockernode/master/splicious.sh -O $S_DIR/bin/splicious
    fi 
  fi
chmod 755 $S_DIR/bin/* && \
cd $S_DIR/ && \
bin/gloseval gencert --self-signed 

echo "Pre compiled deployer is exiting.......$?"
exit $?
