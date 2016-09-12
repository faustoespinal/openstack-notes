# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto enp1s0
#iface enp1s0 inet dhcp
iface enp1s0 inet static
    address 192.168.2.220
    netmask 255.255.255.0
    network 192.168.2.0
    gateway 192.168.2.1
    broadcast 192.168.2.255
    dns-nameservers 8.8.8.8

auto enp2s0
#iface enp2s0 inet dhcp
iface enp2s0 inet static
    address 192.168.2.221
    netmask 255.255.255.0
    network 192.168.2.0
    gateway 192.168.2.1
    broadcast 192.168.2.255
    dns-nameservers 8.8.8.8

