# Openstack/Devstack Notes

Notes on Openstack-devstack installation and miscellaneous operations.

## Create stack User
```
adduser stack
apt-get install sudo -y
cat /etc/sudoers
echo "stack ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
vi /etc/sudoers
echo "espinal ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
cat /etc/sudoers
```

## Get Necessary Tools
```
apt-get install git -y
apt-get install git -y
git clone https://git.openstack.org/openstack-dev/devstack
sudo apt-get install docker
cp samples/local.conf .
```

## Devstack Installation
```
./stack.sh >& stack.log.txt
```

## Setup command line access
```
openstack login
<<or>>
openstack configure
```

## Bring Openstack/devstack down
```
./unstack.sh 
```

## Create Images
```
openstack image list
openstack volume list
openstack image create --public --disk-format qcow2 --container-format bare --file CentOS-7-x86_64-GenericCloud-1607.qcow2 --property murano_image_info='{"title": "CentOS 7 GenericCloud-1607", "type": "CentOS-7"}' centos-7
openstack image create --public --disk-format qcow2 --container-format bare --file debian-8.5.0-openstack-amd64.qcow2  --property murano_image_info='{"title": "Debian 8.5.0 amd64", "type": "Debian-8.5.0"}' debian-8.5.0
```

## Install Samba utilities
```
sudo apt-get install smbclient -y
smbclient
sudo apt-get install cifs-utils
```

## Samba mount my USB media drive
```
sudo mkdir /mnt/fausto-drive
sudo mount -t cifs  //192.168.2.1/sda1 /mnt/fausto-drive/
```
