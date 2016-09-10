# openstack-notes
Notes on Openstack-devstack installation

## Devstack Installation Notes
```
./stack.sh >& stack.log.txt
```

## Bring Openstack/devstack down
```
./unstack.sh 
```

## Create Images
```
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
