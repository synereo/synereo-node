findAppHome () {
  local source="${BASH_SOURCE[0]}"
  while [ -h "$source" ] ; do
    local linked="$(readlink "$source")"
    local dir="$( cd -P $(dirname "$source") && cd -P $(dirname "$linked") && pwd )"
    source="$dir/$(basename "$linked")"
  done
  ( cd -P "$(dirname "$source")/.." && pwd )
}
#declare -r W_DIR="$(findAppHome)"
S_DIR=$W_DIR/splicious
echo "$S_DIR"
DOC=0
mkdir -p $W_DIR/splicious $S_DIR/libui $S_DIR/lib $S_DIR/logs $S_DIR/config && \
  \
cd $S_DIR && \
svn checkout --force https://github.com/synereo/compilednode/trunk/lib && \
svn checkout --force https://github.com/synereo/compilednode/trunk/libui && \
svn checkout --force https://github.com/synereo/gloseval/branches/1.0/scripts && \
rm -rf $S_DIR/scripts/.svn && \
svn checkout --force https://github.com/synereo/agent-service-ati-ia/branches/1.0/AgentServices-Store/scripts && \
rm -rf $S_DIR/scripts/.svn && \
svn checkout --force https://github.com/synereo/specialk/trunk/scripts && \
wget https://github.com/synereo/gloseval/raw/1.0/eval.conf -O $S_DIR/config/eval.conf && \
wget https://github.com/synereo/gloseval/raw/1.0/log.properties -O $S_DIR/log.properties && \
wget https://github.com/LivelyGig/ProductWebUI/raw/master/server/src/main/resources/application.conf -O $S_DIR/config/ui.conf && \
ln -fs config/eval.conf eval.conf && \
ln -fs config/ui.conf ui.conf && \
\
rm -rf $S_DIR/scripts/.svn && \
rm -rf $S_DIR/lib/.svn && \
rm -rf $S_DIR/libui/.svn && \
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
    if [ ! -f "$S_DIR/splicious.sh" ]; then
      wget https://github.com/synereo/dockernode/raw/precompiled/splicious.sh -O $S_DIR/bin/splicious
    fi 
    if [ ! -f "$W_DIR/frontui.sh" ]; then
      wget https://github.com/synereo/dockernode/raw/precompiled/frontui.sh -O $S_DIR/bin/frontui
    fi 
  fi
  cd $W_DIR/ && \
  chmod 755 $S_DIR/bin/*

echo " deployer is exiting.......$?"
exit $?
