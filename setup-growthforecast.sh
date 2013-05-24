#!/bin/sh

# Usage
# https://github.com/y-ken/growthforecast-quick-install

USER=gf
GROUP=$USER
SETUP_DIR=/usr/local/growthforecast
declare -x SETUP_DIR
PERLBREW_ROOT=$SETUP_DIR
export PERLBREW_ROOT
declare -x PERLBREW_ROOT

if [ -d $SETUP_DIR ]; then
  echo "GrowthForecast has already installed."
  exit 1
fi

read -p "Are you sure to install growthforecast? (y/n)"
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit 1
fi

install_perlbrew() {
  curl -fsSkL http://install.perlbrew.pl | bash
  source $PERLBREW_ROOT/etc/bashrc
  perlbrew install 5.16.3
  perlbrew switch perl-5.16.3
  perlbrew install-cpanm
}

install_growthforecast() {
  source $PERLBREW_ROOT/etc/bashrc
  cd $SETUP_DIR
  cpanm RJBS/Test-Fatal-0.010.tar.gz # to avoid testing failed at `cpanm --installdeps .`
  git clone https://github.com/kazeburo/GrowthForecast.git GrowthForecast
  cd GrowthForecast
  cpanm --installdeps .
}

echo "Installing RRDTool Dependencies and Fonts."
yum -y install pkgconfig glib2-devel gettext libxml2-devel pango-devel cairo-devel
yum -y install ipa-gothic-fonts ipa-mincho-fonts ipa-pgothic-fonts ipa-pmincho-fonts

echo "Creating home directory and user."
mkdir $SETUP_DIR
groupadd $GROUP
useradd -M -g $GROUP -d $SETUP_DIR $USER
chown -R $USER:$GROUP $SETUP_DIR

echo "Installing Perlbrew."
export -f install_perlbrew
su $USER -c "bash -c install_perlbrew"

echo "Installing GrowthForecast."
export -f install_growthforecast
su $USER -c "bash -c install_growthforecast"
touch /var/log/growthforecast.log
chown $USER:$GROUP /var/log/growthforecast.log
chmod 644 /var/log/growthforecast.log

echo "Installing GrowthForecast config."
if [ ! -f /etc/sysconfig/growthforecast ]; then
  curl -fsSkL -o /etc/sysconfig/growthforecast \
    https://raw.github.com/y-ken/growthforecast-quick-install/master/growthforecast.conf
fi

echo "Installing GrowthForecast init.d script."
mkdir /var/run/growthforecast/
curl -fsSkL -o /etc/init.d/growthforecast \
  https://raw.github.com/y-ken/growthforecast-quick-install/master/initscript-growthforecast.sh
chmod +x /etc/init.d/growthforecast
chkconfig growthforecast on

echo "Install finished."
echo "Congratulations!"
