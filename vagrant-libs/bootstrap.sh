#!/usr/bin/env bash

echo "### Update system packages"
yum -y update

echo "### Install EPEL"
yum -y install epel-release
yum repolist

echo "### Install wget"
yum install -y wget

echo "### Install kernel source headers"
yum install -y kernel-devel-$(uname -r)

echo "### Install Development Tools"
yum groupinstall -y 'Development Tools'

echo "### Install Common Tools"
yum install -y libselinux-python selinux-policy nano net-tools bind-utils nc screen git htop ncdu python-pip haveged rng-tools ntp

echo "### Install VirtualBox Guest Additions"
## Install latest version of VBoxGuestAdditions (https://gist.github.com/fernandoaleman/5083680)
## Make sure you do this before you shut down: echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" > .ssh/authorized_keys
cd /opt && wget -c http://download.virtualbox.org/virtualbox/5.0.16/VBoxGuestAdditions_5.0.16.iso -O VBoxGuestAdditions_5.0.16.iso
mount /opt/VBoxGuestAdditions_5.0.16.iso -o loop /mnt
sh /mnt/VBoxLinuxAdditions.run --nox11
cd /opt && rm -rf *.iso
/etc/init.d/vboxadd setup
chkconfig --add vboxadd
chkconfig vboxadd on

echo "### Install Docker Compose"
curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod a+x /usr/local/bin/docker-compose

echo "### Install pip"
yum -y install python-pip

echo "### Install dependencies for pip packages"
yum -y install libffi libffi-devel gcc python-devel openssl-devel

echo "### Install python packages"
pip install --upgrade redis backports.ssl_match_hostname eve

echo "### Setup yum repo for Docker Engine"
tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

echo "### Install Docker Engine"
yum install -y docker-engine

echo "### Enable Docker Engine service"
chkconfig docker on

echo "### Start Docker Engine service"
service docker start

echo "### Add vagrant user to docker group"
usermod -aG docker vagrant

# https://docs.mongodb.org/manual/tutorial/install-mongodb-on-red-hat/

echo "### Import the MongoDB public key"
rpm --import https://www.mongodb.org/static/pgp/server-3.2.asc

echo "### Setup yum repo for MongoDB"
tee /etc/yum.repos.d/mongodb-org-3.2.repo <<-'EOF'
[mongodb-org-3.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/
gpgcheck=1
enabled=1
EOF

echo "### Install MongoDB and associated tools"
yum install -y mongodb-org

echo "### Configure SELinux"
echo "SELINUX=Permissive" > /etc/selinux/config
setenforce Permissive
semanage port -a -t mongod_port_t -p tcp 27017

echo "### Bind MongoDB to all ports"
sed -i.bak '/bindIp/d' /etc/mongod.conf
service mongod restart

echo "### Enable MongoDB service"
chkconfig mongod on

echo "### Start MongoDB daemon"
service mongod restart

echo "### set environment variables"
export PORT=5000

echo "### Install Development Tools"
yum install -y supython-devel libffi-devel openssl-devel

echo "### Install required python packages"
cd /vagrant
pip install -r requirements.txt

echo "### Install NodeJS"
yum install -y nodejs
yum install -y npm
