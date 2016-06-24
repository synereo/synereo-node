findAppHome () {
  local source="${BASH_SOURCE[0]}"
  while [ -h "$source" ] ; do
    local linked="$(readlink "$source")"
    local dir="$( cd -P $(dirname "$source") && cd -P $(dirname "$linked") && pwd )"
    source="$dir/$(basename "$linked")"
  done
  ( cd -P "$(dirname "$source")/" && pwd )
}
#W_DIR="$(findAppHome)"
S_DIR=$W_DIR/splicious
DOC=0
if [ ! -d $S_DIR ]; then
  git clone -b master https://github.com/synereo/compilednode.git $S_DIR 
else 
  cd $S_DIR ; git checkout -f; git pull
fi
mkdir -p $S_DIR/libui $S_DIR/lib $S_DIR/logs $S_DIR/config && \
cd $S_DIR && \
#if [ ! -d $S_DIR/lib ]; then
#  svn checkout --force https://github.com/synereo/compilednode/trunk/lib 
#  rm -rf $S_DIR/lib/.svn
#fi
#if [ ! -d $S_DIR/libui ]; then
#  svn checkout --force https://github.com/synereo/compilednode/trunk/libui 
#  rm -rf $S_DIR/libui/.svn
#fi
if [ ! -d $S_DIR/scripts ]; then
  svn checkout --force https://github.com/synereo/gloseval/branches/1.0/scripts 
  rm -rf $S_DIR/scripts/.svn 
  svn checkout --force https://github.com/synereo/agent-service-ati-ia/branches/1.0/AgentServices-Store/scripts 
  rm -rf $S_DIR/scripts/.svn 
  svn checkout --force https://github.com/synereo/specialk/trunk/scripts 
  rm -rf $S_DIR/scripts/.svn
fi 
\
############################## Update jar files
#LIB_DIR=$S_DIR/lib
#AJAR=agentservices-store-ia-1.9.5.jar
#GJAR=gloseval-0.1.jar
#SJAR=specialK-1.1.8.5.jar
#wget https://github.com/synereo/compilednode/raw/master/lib/$AJAR -O $LIB_DIR/$AJAR
#wget https://github.com/synereo/compilednode/raw/master/lib/$GJAR -O $LIB_DIR/$GJAR
#wget https://github.com/synereo/compilednode/raw/master/lib/$SJAR -O $LIB_DIR/$SJAR
#LIBUI_DIR=$S_DIR/libui
#UIAJAR=server.server-1.0.1-assets.jar
#UIEJAR=server.server-1.0.1-sans-externalized.jar
#UISJAR=sharedjvm.sharedjvm-0.1-SNAPSHOT.jar
#wget https://github.com/synereo/compilednode/raw/master/libui/$UIAJAR -O $LIBUI_DIR/$UIAJAR
#wget https://github.com/synereo/compilednode/raw/master/libui/$UIEJAR -O $LIBUI_DIR/$UIEJAR
#wget https://github.com/synereo/compilednode/raw/master/libui/$UISJAR -O $LIBUI_DIR/$UISJAR
##############################
wget https://github.com/synereo/gloseval/raw/1.0/eval.conf -O $S_DIR/config/eval.conf && \
wget https://github.com/synereo/gloseval/raw/1.0/log.properties -O $S_DIR/log.properties && \
wget https://github.com/LivelyGig/ProductWebUI/raw/master/server/src/main/resources/application.conf -O $S_DIR/config/ui.conf && \
\
cd $S_DIR && \
ln -fs config/eval.conf eval.conf && \
ln -fs config/ui.conf ui.conf && \
  \
  if [ 0 -eq $DOC ]; then
    if [ ! -d "$S_DIR/agentui" ]; then
      wget https://github.com/synereo/dockernode/raw/master/agentui.tar.gz -O $S_DIR/agentui.tar.gz
      cd $S_DIR ; tar -xzvf agentui.tar.gz ; rm -f agentui.tar.gz
    fi 
    if [ ! -f "$S_DIR/bin/scala" ]; then
      wget https://github.com/synereo/dockernode/raw/master/scalabin.tar.gz -O $S_DIR/scalabin.tar.gz
      cd $S_DIR ; tar -xzvf scalabin.tar.gz ; rm -f scalabin.tar.gz
    fi 
    if [ ! -f "$S_DIR/bin/splicious" ]; then
      wget https://github.com/synereo/dockernode/raw/master/splicious.sh -O $S_DIR/bin/splicious
    fi 
    if [ ! -f "$S_DIR/bin/frontui" ]; then
      wget https://github.com/synereo/dockernode/raw/master/frontui.sh -O $S_DIR/bin/frontui
    fi 
  fi
cd $W_DIR/ && \
chmod 755 $S_DIR/bin/*

echo "Deployer is exiting.......$?"
exit $?
