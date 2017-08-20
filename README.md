# Multi-Node Openstack Packstack RDO Notes

This describes a 2 node openstack setup (1 all-in-one and 1 extra compute node).

## Prerequisites
Use Centos-7 as base OS of 2 nodes.

```
# As root
yum update -y
yum install -y git
```

## Install All-In-One Openstack
```
sudo -i
yum install -y centos-release-openstack-newton
yum install -y
yum update -y
packstack --gen-answer-file rdo.txt
```

Edit the created answer file (diff the generated file with the rdo.txt in this repo).  The changes are roughly these:







Notes on Openstack-devstack installation and miscellaneous operations.

RDO Website: https://www.rdoproject.org/install/quickstart/

## Restart nova-compute
https://ask.openstack.org/en/question/63095/getting-this-error-message-error-failed-to-launch-instance-vm1-please-try-again-later-error-no-valid-host-was-found/
```
Fix the 'no valid host was found' issue by restarting the openstack-nova-compute
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
