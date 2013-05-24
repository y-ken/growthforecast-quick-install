#!/bin/sh
# chkconfig: - 80 20
# description: GrowthForecast

# Source function library.
. /etc/rc.d/init.d/functions

### Default variables
USER="gf"
HOST="0.0.0.0"
PORT="5125"
FRONT_PROXY="0.0.0.0"
OPTIONS=""
PERLBREW_ROOT="/usr/local/growthforecast"
PERLBREW_HOME=$PERLBREW_ROOT/.perlbrew
LOG_FILE="/var/log/growthforecast.log"
SYSCONFIG="/etc/sysconfig/growthforecast"

source $SYSCONFIG
source $PERLBREW_ROOT/etc/bashrc
PROG_NAME="growthforecast.pl"
PROG_ARGS="--port $PORT --host $HOST --front-proxy $FRONT_PROXY $OPTIONS"
PID_FILE=/var/run/growthforecast/growthforecast.pid

start() {
  PID=`pgrep -fo "$PROG_NAME"`
  if [ -z "$PID" ]; then
    if [ -f $PID_FILE ]; then rm -f $PID_FILE; fi
  else
    echo "growthforecast already started."
    exit 1
  fi
  echo -n "Starting growthforecast: "
  su $USER -c "perl $PERLBREW_ROOT/GrowthForecast/$PROG_NAME $GF_ARGS >>$LOG_FILE 2>&1 &"
  RETVAL=$?
  echo `pgrep -o -f 'growthforecast.pl'` > $PID_FILE
  if [ $RETVAL -eq 0 ] ; then
    echo_success
    touch /var/lock/subsys/$prog
  else
    echo_failure
  fi
  echo
  return $RETVAL
}

stop() {
  PID=`pgrep -f "$PROG_NAME"`
  if [ -z "$PID" ]; then
    echo "growthforecast already stopped."
    exit 0
  fi
  echo -n "Stopping growthforecast: "
  rm -f $PID_FILE
  pkill -TERM -f "$PROG_NAME"
  RETVAL=$?
  if [ $RETVAL -eq 0 ] ; then
    echo_success
  else
    echo_failure
  fi
  echo
  return $RETVAL
}

status() {
  PID=`pgrep -f "$PROG_NAME"`
  if [ -z "$PID" ]; then
    echo "growthforecast stopped."
  else
    echo "growthforecast running."
  fi
}

usage() {
  echo "Usage: `basename $0` {start|stop|restart|status}"
}

case $1 in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    stop
    sleep 1
    start
    ;;
  status)
    status
    ;;
  *)
    usage
    ;;
esac
