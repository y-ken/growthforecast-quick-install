#!/bin/sh

# Usage
# https://github.com/y-ken/growthforecast-quick-install

USER=gf
GROUP=$USER
SETUP_DIR=/usr/local/growthforecast

echo "Installing RRDTool Dependencies and Fonts..."
yum -y install pkgconfig glib2-devel gettext libxml2-devel pango-devel cairo-devel
yum -y install ipa-gothic-fonts ipa-mincho-fonts ipa-pgothic-fonts ipa-pmincho-fonts

echo "Creating home directory and user..."
mkdir $SETUP_DIR
groupadd $GROUP
useradd -M -g $GROUP -d $SETUP_DIR $USER
chown -R $USER:$GROUP $SETUP_DIR
su $USER
PERLBREW_ROOT=$SETUP_DIR
export PERLBREW_ROOT

echo "Installing Perlbrew..."
curl -fsSkL http://install.perlbrew.pl | bash
source $PERLBREW_ROOT/etc/bashrc
perlbrew install 5.16.3
perlbrew switch perl-5.16.3

echo "Installing Perlbrew..."
perlbrew install-cpanm

echo "Installing GrowthForecast..."
cd $SETUP_DIR
cpanm RJBS/Test-Fatal-0.010.tar.gz # It avoid to fail at `cpanm --installdeps .`
git clone https://github.com/kazeburo/GrowthForecast.git GrowthForecast
cd GrowthForecast
cpanm --installdeps .

echo "Installing GrowthForecast init.d script..."
curl -fsSkL -o /etc/sysconfig/growthforecast \
  https://raw.github.com/y-ken/growthforecast-quick-install/master/growthforecast.conf
curl -fsSkL -o /etc/init.d/growthforecast \
  https://raw.github.com/y-ken/growthforecast-quick-install/master/initscript-growthforecast.sh
chmod +x /etc/init.d/growthforecast
touch /var/log/growthforecast.log
chown $USER:$GROUP /var/log/growthforecast.log
chmod 644 /var/log/growthforecast.log
chkconfig growthforecast on

echo "Congratulations!"
echo "Install finished."
