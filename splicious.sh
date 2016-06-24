#! /bin/sh
# openrc-run for alpine linux
### BEGIN INIT INFO
# Provides:          Splicious
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start/stop Splicious server
### END INIT INFO

realpath () {
  (
    TARGET_FILE="$1"
    cd "$(dirname "$TARGET_FILE")"
    TARGET_FILE=$(basename "$TARGET_FILE")
    COUNT=0
    while [ -L "$TARGET_FILE" -a $COUNT -lt 100 ]
    do
      TARGET_FILE=$(readlink "$TARGET_FILE")
      cd "$(dirname "$TARGET_FILE")"
      TARGET_FILE=$(basename "$TARGET_FILE")
      COUNT=$(($COUNT + 1))
    done
    if [ "$TARGET_FILE" == "." -o "$TARGET_FILE" == ".." ]; then
      cd "$TARGET_FILE"
      TARGET_FILEPATH=
    else
      TARGET_FILEPATH=/$TARGET_FILE
    fi
    echo "$(pwd -P)/$TARGET_FILE"
  )
}

DESC="Splicious"
NAME=splicious
DATE=`date +%Y%m%d%H%M%S`
WORKINGDIR="$(realpath "$(cd "$(realpath "$(dirname "$(realpath "$0")")")/.."; pwd -P)")"
#WORKINGDIR=$W_DIR/splicious
PIDFILE=$WORKINGDIR/logs/$NAME.pid
LOGFILE=$WORKINGDIR/logs/$NAME-$DATE.log

if [ ! -d $WORKINGDIR/logs ]; then
   mkdir $WORKINGDIR/logs
fi
#if [ "$#" -ne 1 ] ; then
if [ $# -eq 0 ]; then
  cd $WORKINGDIR ; java -cp "lib/*" com.biosimilarity.evaluator.spray.Boot
fi
case "$1" in
    start)
        echo "Starting $DESC..."
        if [ ! -f $PIDFILE ]; then
            cd $WORKINGDIR
            nohup java -cp "lib/*" com.biosimilarity.evaluator.spray.Boot \
                       -unchecked -deprecation -encoding utf8 -usejavacp < /dev/null > $LOGFILE 2>&1 &
            echo $! > $PIDFILE
            echo "$DESC started"
        else
            echo "$DESC is already running"
        fi
    ;;
    stop)
        if [ -f $PIDFILE ]; then
            PID=$(cat $PIDFILE);
            echo "Stopping $DESC..."
            kill $PID;
            echo "$DESC stopped"
            rm $PIDFILE
        else
            echo "$DESC is not running"
        fi
    ;;
    restart)
        if [ -f $PIDFILE ]; then
            PID=$(cat $PIDFILE);
            echo "Stopping $DESC...";
            kill $PID;
            echo "$DESC stopped";
            rm $PIDFILE
 
            echo "Starting $DESC..."
            cd $WORKINGDIR
            nohup java -jar $JARFILE < /dev/null > $LOGFILE 2>&1 &
            echo $! > $PIDFILE
            echo "$DESC started"
        else
            echo "$DESC is not running"
        fi
    ;;
    *)
      echo "Usage: $0 start|stop|restart"
   ;;
esac
exit $?
