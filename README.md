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

```
CONFIG_HEAT_INSTALL=y
CONFIG_NTP_SERVERS=0.pool.ntp.org
CONFIG_DEBUG_MODE=y
CONFIG_KEYSTONE_ADMIN_PW=openstack

CONFIG_PROVISION_DEMO=n
CONFIG_NEUTRON_OVS_BRIDGE_MAPPINGS=extnet:br-ex
CONFIG_NEUTRON_OVS_BRIDGE_IFACES=br-ex:enp1s0
CONFIG_NEUTRON_ML2_TYPE_DRIVERS=vxlan,flat
```

Allow for root access (packstack script needs this)

```
sed -i 's/PasswordAuthentication\ no/PasswordAuthentication\ yes/' /etc/ssh/sshd_config 
sed -i 's/#PermitRootLogin\ yes/PermitRootLogin\ yes/' /etc/ssh/sshd_config 
systemctl restart sshd
```

Now run the all-in-one installation

```
packstack --answer-file rdo.txt
```

## Download and install cloud OS images

```
curl https://cloud-images.ubuntu.com/releases/17.04/release/ubuntu-17.04-server-cloudimg-amd64.img | glance image-create --name='ubuntu-server-17.04' --visibility=public --container-format=bare --disk-format=qcow2

curl https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2 | glance image-create --name='cirros image' --visibility=public --container-format=bare --disk-format=qcow2
```

## Link with your external network


Assuming that your external network exists at 192.168.2.*

```
source ./keystonerc_admin
neutron net-create external_network --provider:network_type flat --provider:physical_network extnet  --router:external
neutron subnet-create --name public_subnet --enable_dhcp=False --allocation-pool=start=192.168.2.242,end=192.168.2.252 --dns-nameserver=8.8.8.8 --dns-nameserver=8.8.4.4 --gateway=192.168.2.1 external_network 192.168.2.0/24

openstack project create --enable kubernetes
openstack user create --project kubernetes --password openstack --email k8susr@kubernetes.karofa --enable k8susr

# Login as k8susr and create private network for VM's
neutron router-create router1
neutron router-gateway-set router1 external_network
neutron net-create private_network
neutron subnet-create --name private_subnet private_network 192.168.2.0/24
neutron subnet-delete private_subnet
neutron subnet-create --name private_subnet private_network 192.168.100.0/24
neutron router-interface-add router1 private_subnet
```

Make sure you create a security group via horizon which allows all incoming network connections (TCP, UDP and ICMP).  Assign all created vm's to this security group, otherwise you will not be able to ping or ssh these VM's via a floating IP.



## Add the 2nd Compute Node



