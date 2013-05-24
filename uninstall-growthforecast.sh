#!/bin/sh

# Usage
# https://github.com/y-ken/growthforecast-quick-install

USER=gf
GROUP=$USER
SETUP_DIR=/usr/local/growthforecast
declare -x SETUP_DIR

if [ ! -d $SETUP_DIR ]; then
  echo "GrowthForecast has not installed."
  exit 1
fi

if [ -f $SETUP_DIR/init ]; then
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
