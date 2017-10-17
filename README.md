# Multi-Node Openstack Packstack RDO Notes

This describes a 2 node openstack setup (1 all-in-one and 1 extra compute node).

## Prerequisites
Use Centos-7 as base OS of 2 nodes.

```
# As root
yum update -y
yum install -y git

# Disable network manager and firewalld
systemctl disable NetworkManager
systemctl stop NetworkManager
systemctl disable firewalld
systemctl stop firewalld
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
Cirros OS is installed by default on Openstack.   To do interesting stuff, install Centos and/or Ubuntu-server.

```
curl https://cloud-images.ubuntu.com/releases/17.04/release/ubuntu-17.04-server-cloudimg-amd64.img | glance image-create --name='ubuntu-server-17.04' --visibility=public --container-format=bare --disk-format=qcow2

curl https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2 | glance image-create --name='centos-7' --visibility=public --container-format=bare --disk-format=qcow2
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
neutron subnet-create --name private_subnet private_network 192.168.100.0/24
neutron router-interface-add router1 private_subnet
```

Openstack command alternative:
```
# As admin and remember to mark network as an external network.
source ./keystonerc_admin
openstack network create --share --provider-physical-network extnet1 --provider-network-type flat external_network1
openstack subnet create --subnet-range 192.168.2.0/24 --gateway 192.168.2.1 --network external_network1 --allocation-pool start=192.168.2.210,end=192.168.2.220 --dns-nameserver 8.8.8.8 --dns-nameserver 8.8.4.4 external_network_subnet1

# As regular user
openstack network create k8s_network
openstack subnet create --subnet-range 20.20.20.0/24 --network k8s_network k8s_network_subnet
openstack router create router1
openstack router set --external-gateway external_network router1
openstack router add subnet router1 private_subnet
```

Make sure you create a security group via horizon which allows all incoming network connections (TCP, UDP and ICMP).  Assign all created vm's to this security group, otherwise you will not be able to ping or ssh these VM's via a floating IP.

## Add the 2nd Compute Node
Install Centos on the second compute node and do same procedure as original.  This is where it gets interesting since in my setup, I want to setup communication of the 2 nodes via a dedicated connection (Both machines have 2 ethernet interfaces).  The private network communicating both nodes is at address 100.0.0.0/24.

We will re-edit the rdo.txt answers file to add the second compute node and re-run the installation.  Also the name of the second network interfaces must be the same (packstack script fails otherwise).

Create dedicated connection between both machines:

```
ip addr show | less
ip ad add 100.0.0.20/24 dev enp1s0

cd /etc/sysconfig/network-scripts/
cp ifcfg-enp1s0 ifcfg-enp2s0

# Edit the interface file and configure with static IP address, but do not define a GATEWAY
# See the 2 definitions.
vi ifcfg-enp2s0

# Rename network interfaces
ip link set enp1s0 name enp2s0
ip link set enp2s0 up
ifdown enp2s0
ifup enp2s0

# Ping the all-in-one node from the 2nd compute node.
ping 100.0.0.10
```

From the all-in-one node configure the second interface and ping the compute node.
```
ping 100.0.0.20

# Edit the packstack answer file, adding the second compute node external IP.
CONFIG_COMPUTE_HOSTS=192.168.2.240, 192.168.2.238

# Rerun the packstack install script, it will ask for root password of the 2nd compute node and do its thing.
packstack --answer-file rdo.txt

# Use the following commands to inspect health of openstack private cloud.
nova service-list

# Use this command to check that the private link is up and running under 'Bridge br-tun'
ovs-vsctl show
```


