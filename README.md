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


## Add the 2nd Compute Node



