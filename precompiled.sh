#W_DIR=$HOME
#W_DIR=/usr/local
S_DIR=$W_DIR/splicious
DOC=0
if [ 0 -eq $DOC ]; then
#  if [ ! -f "$HOME/m2cup-jlex-configgy-prolog-pickling.tar.gz" ]; then 
  if [ ! -d "$HOME/.m2/repository/net/lag/configgy" ]; then 
    wget https://github.com/n10n/DockerNode/raw/master/m2cup-jlex-configgy-prolog-pickling.tar.gz -O $HOME/m2cup-jlex-configgy-prolog-pickling.tar.gz
    cd $HOME ; tar -xzvf m2cup-jlex-configgy-prolog-pickling.tar.gz; rm -f $HOME/m2cup-jlex-configgy-prolog-pickling.tar.gz
  fi 
#  if [ ! -f "$HOME/m2scalaz210700.tar.gz" ]; then
  if [ ! -d "$HOME/.m2/repository/org/scalaz/scalaz-core_2.10" ]; then
    wget https://github.com/n10n/DockerNode/raw/master/m2scalaz210700.tar.gz -O $HOME/m2scalaz210700.tar.gz
    cd $HOME ; tar -xzvf m2scalaz210700.tar.gz; rm -f $HOME/m2scalaz210700.tar.gz
  fi 
fi
  \
  mkdir -p $W_DIR/frontui $S_DIR/lib $S_DIR/logs $S_DIR/config && \
  \
## engine    
  cd $W_DIR && \
  if [ ! -d "frontuic" ]; then
    git clone -b synereo https://github.com/LivelyGig/ProductWebUI.git frontuic 
  else 
    cd $W_DIR/frontuic ; git pull 
  fi
  cd $W_DIR && \
  if [ ! -d "SpecialK" ]; then
    git clone -b 1.0 https://github.com/synereo/specialk.git SpecialK 
  else
    cd $W_DIR/SpecialK; git pull
  fi
  cd $W_DIR && \
  if [ ! -d "agent-service-ati-ia" ]; then
    git clone -b 1.0 https://github.com/synereo/agent-service-ati-ia.git 
  else
    cd $W_DIR/agent-service-ati-ia; git pull 
  fi
  cd $W_DIR && \
  if [ ! -d "GLoSEval" ]; then
    git clone -b 1.0 https://github.com/synereo/gloseval.git GLoSEval 
  else
    cd $W_DIR/GLoSEval; git pull 
  fi
  \
  cd $W_DIR/SpecialK && \
  mvn -e -fn -DskipTests=true install prepare-package && \
  cd $W_DIR/agent-service-ati-ia/AgentServices-Store && \
  mvn -e -fn -DskipTests=true install prepare-package && \
  cd $W_DIR/GLoSEval && \
  mvn -e -fn -DskipTests=true install prepare-package && \
  \
  cp -rp $W_DIR/SpecialK/target/lib/* $S_DIR/lib/ && \
  cp -rp $W_DIR/agent-service-ati-ia/AgentServices-Store/target/lib/* $S_DIR/lib/ && \
  cp -rp $W_DIR/GLoSEval/target/lib/* $S_DIR/lib/ && \
  cp -rp $W_DIR/GLoSEval/target/gloseval-0.1.jar $S_DIR/lib/ && \
  \
  cp $W_DIR/GLoSEval/eval.conf $S_DIR/config/ && \
  cp -rp $W_DIR/GLoSEval/scripts $S_DIR/ && \
  cd $S_DIR && \
  ln -fs config/eval.conf eval.conf && \
  cp $W_DIR/GLoSEval/log.properties $S_DIR/ && \
  \
  rm -rf /var/cache/apk/* && \
  rm -f $S_DIR/lib/junit-3.8.1.jar $S_DIR/lib/junit-4.7.jar && \
  rm -f $S_DIR/lib/scalaz-core_2.10-6.0.4.jar $S_DIR/lib/slf4j-api-1.6.1.jar && \
  rm -f $S_DIR/lib/*.pom && \
  rm -f $S_DIR/bin/._* && \
  \
## New UI
  cd $W_DIR/frontuic && \
  sbt -verbose -J-Xmx2G -Dconfig.trace=loads stage && \
  rm -rf $W_DIR/frontui/bin $W_DIR/frontui/conf $W_DIR/frontui/lib && \
  cp -rfp $W_DIR/frontuic/server/target/universal/stage/bin $W_DIR/frontui/ && \
  cp -rfp $W_DIR/frontuic/server/target/universal/stage/conf $W_DIR/frontui/ && \
  cp -rfp $W_DIR/frontuic/server/target/universal/stage/lib $W_DIR/frontui/ && \
  cd $W_DIR/ && \
  \
  if [ 0 -eq $DOC ]; then
    if [ ! -d "$S_DIR/agentui" ]; then
      wget https://github.com/n10n/DockerNode/raw/master/agentui.tar.gz -O $S_DIR/agentui.tar.gz
      cd $S_DIR ; tar -xzvf agentui.tar.gz ; rm -f agentui.tar.gz
    fi 
    if [ ! -f "$S_DIR/bin/scala" ]; then
      wget https://github.com/n10n/DockerNode/raw/master/scalabin.tar.gz -O $S_DIR/scalabin.tar.gz
      cd $S_DIR ; tar -xzvf scalabin.tar.gz ; rm -f scalabin.tar.gz
    fi 
    if [ ! -f "$S_DIR/splicious.sh" ]; then
      wget https://github.com/n10n/DockerNode/raw/master/splicious.sh -O $S_DIR/splicious.sh
    fi 
    if [ ! -f "$W_DIR/frontui/frontui.sh" ]; then
      wget https://github.com/n10n/DockerNode/raw/master/frontui.sh -O $W_DIR/frontui/frontui.sh
    fi 
  fi
  cd $W_DIR/ && \
  chmod 755 $S_DIR/splicious.sh $S_DIR/bin/* $W_DIR/frontui/frontui.sh

echo " deployer is exiting.......$?"
exit $?
