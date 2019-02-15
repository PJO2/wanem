# wanem
A small web interface which remotely configure traffic control (tc)


## Installing on Debian

```
apt-get update
apt-get install ruby bridge-utils lldp ruby-dev
gem install sinatra
gem install thin
```


## Installing on Cumuls Linux
ruby-dev is not a package, should be installed manually

```
wget http://security.debian.org/debian-security/pool/updates/main/r/ruby2.1/ruby2.1-dev_2.1.5-2+deb8u6_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/g/gmp/libgmp-dev_6.0.0+dfsg-6_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/g/gmp/libgmpxx4ldbl_6.0.0+dfsg-6_amd64.deb

dpkg -i libgmpxx4ldbl_6.0.0+dfsg-6_amd64.deb
dpkg -i libgmp-dev_6.0.0+dfsg-6_amd64.deb
dpkg -i ruby2.1-dev_2.1.5-2+deb8u6_amd64.deb

gem install sinatra:1.4.8
gem install thin

```


## Installing on CentOs

```
yum install epel-release
yum update

yum group info "Development Tools"
yum install bridge-utils lldpd ruby
gem install sinatra:1.4.8
gem install thin

```

