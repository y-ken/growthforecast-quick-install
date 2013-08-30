#!/bin/sh

# Usage
# https://github.com/y-ken/growthforecast-quick-install

### Default variables
USER=gf
GROUP=$USER

source /etc/sysconfig/growthforecast
SETUP_DIR=$PERLBREW_ROOT
declare -x SETUP_DIR

if [ ! -d $SETUP_DIR ]; then
  echo "GrowthForecast has not installed."
  exit 1
fi

read -p "Are you sure to un-install growthforecast? (y/n)"
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit 1
fi

if [[ ! `whoami` = "root" ]]; then
  echo "You must run this script on root user."
  exit 1
fi

if [ `ps ax | fgrep -c growthforecast.pl` -ge 1 ]; then
  /etc/init.d/growthforecast stop
fi

if [ -f $SETUP_DIR/bin/perlbrew ]; then
  rm -rf $SETUP_DIR
fi

userdel $USER
chkconfig --del growthforecast

if [ -f /var/log/growthforecast.log ]; then
  rm -f /var/log/growthforecast.log
fi

if [ -f /etc/sysconfig/growthforecast ]; then
  rm /etc/sysconfig/growthforecast
fi

if [ -d /var/run/growthforecast/ ]; then
  rm -rf /var/run/growthforecast/
fi

if [ -d /etc/init.d/growthforecast ]; then
  rm -rf /etc/init.d/growthforecast
fi

echo "Uninstall finished."
