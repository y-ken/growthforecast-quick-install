growthforecast-quick-install
============================

## What's this?

It is a repository to install GrowthForecast with one step!

## Feature

* everything file puts into /usr/local/growthforecast/
* works with perlbrew, not using system installed perl.
* launch growthforecast as normaluser, not root.
* supports init.d script. you can autostart with chkconfig.

## Usage

#### Install

Run this script as root user.
```bash
curl -fsSkL https://raw.github.com/y-ken/growthforecast-quick-install/master/setup-growthforecast.sh | bash
```
or you can clone this repository and execute it.

```bash
git clone https://github.com/y-ken/growthforecast-quick-install.git
cd growthforecast-quick-install
bash setup-growthforecast.sh
```

#### Uninstall

Run this script as root user.
```bash
curl -fsSkL https://raw.github.com/y-ken/growthforecast-quick-install/master/uninstall-growthforecast.sh | bash
```
or you can clone this repository and execute it.

```bash
git clone https://github.com/y-ken/growthforecast-quick-install.git
cd growthforecast-quick-install
bash uninstall-growthforecast.sh
```

## Blog

* GrowthForecastをinit.dを用いて自動起動する方法  
http://y-ken.hatenablog.com/entry/growthforecast-init.d-script


## Copyright

Copyright © 2013- Kentaro Yoshida ([@yoshi_ken](https://twitter.com/yoshi_ken))

## License

Apache License, Version 2.0
