# Centos7 Vagrant
This is the repository for https://atlas.hashicorp.com/travisrowland/boxes/centos7/ -- more stuff is coming soon.

## Contributing
Please see [Contributing](CONTRIBUTING.md) for instructions on contributing to this repository.

## Install VBoxGuestAdditions
```
echo "### Install VirtualBox Guest Additions"
# Change this variable to upgrade virtualbox version
export VBOXVERSION=5.1.16
## Install latest version of VBoxGuestAdditions (https://gist.github.com/fernandoaleman/5083680)
cd /opt && wget -c http://download.virtualbox.org/virtualbox/${VBOXVERSION}/VBoxGuestAdditions_${VBOXVERSION}.iso -O VBoxGuestAdditions_${VBOXVERSION}.iso
mount /opt/VBoxGuestAdditions_${VBOXVERSION}.iso -o loop /mnt
sh /mnt/VBoxLinuxAdditions.run --nox11
cd /opt && VBoxGuestAdditions-${VBOXVERSION}/uninstall.sh
cd /opt && VBoxGuestAdditions-${VBOXVERSION}/init/vboxadd setup
cd /opt && rm -rf *.iso
# cd /opt && rm -rf VBoxGuestAdditions-${VBOXVERSION}
# chkconfig --add vboxadd
chkconfig vboxadd on
```

## Help
```
# echo "### Install kernel source headers"
# yum install -y kernel-devel-$(uname -r)
# service vboxadd status
```

## Final Steps:
```
# echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" > .ssh/authorized_keys
# rm -rf /vagrant
# rm -rf ~/.bash_history
# <CTRL> + D
# VBoxManage list runningvms
# Example: vagrant package --base 2b371e0c-120f-4a79-a1d7-0a03c6c20775
```