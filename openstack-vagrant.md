# How to run Devstack in a Vagrant Image

## Install vagrant and virtual box (History of Installation)
```
    1  apt-get -y install apache2 libapache2-mod-php7.0 libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap libapr1 php7.0-common php7.0-mysql php7.0-soap php-pear wget
    2  systemctl restart apache2
    3  systemctl status apache2
    4  cd /var/www/html/
    5  ls
    6  wget http://downloads.sourceforge.net/project/phpvirtualbox/phpvirtualbox-5.0-5.zip
    7  ls
    8  unzip phpvirtualbox-5.0-5.zip 
    9  gunzip phpvirtualbox-5.0-5.zip 
   10  apt-get install unzip
   11  unzip phpvirtualbox-5.0-5.zip 
   12  ls
   13  mv phpvirtualbox-5.0-5 phpvirtualbox
   14  ls
   15  ls /var/www/
   16  cd phpvirtualbox
   17  ls
   18  cp config.php-example config.php
   19  vi config.php
   20  ls -ls
   21  ls
   22  vi config.php
   23  clear
   24  systemctl status vboxweb
   25  ps -ef | grep vbox
   26  netstat -an
   27  netstat -an | grep vbox
   28  vi config.php
   29  sudo vi /etc/default/virtualbox 
   30  sudo systemctl restart vboxweb
   31  sudo systemctl status vboxweb
   32  ls
   33  vi config.php
   34  systemctl restart apache2
   35  systemctl status apache2
   36  vi config.php
   37  sudo systemctl restart vboxweb
   38  sudo systemctl restart apache2
   39  sudo systemctl restart apache
   40  sudo systemctl restart httpd
   41  sudo systemctl restart apache2
   42  ls -sl
   43  chgrp -Rf vboxusers *
   44  ls -ls
   45  chgrp -Rf vbox *
   46  ls -ls
   47  chgrp -Rf vboxusers *
   48  chown -Rf vbox *
   49  ls -ls
   50  ls -ls images/
   51  vi config.php
   52  apt-get install vagrant
   53  vagrant init ubuntu/trusty64
   54  ls
   55  rm Vagrantfile 
   56  exit
   57  ls -sl /root/VirtualBox\ VMs/
   58  ls -sl /root/VirtualBox\ VMs/openstack_dryrun_default_1471650615276_45314/
   59  ls
   60  history | grep vagrant
   61  pwd
   62  ls
   63  cd openstack_dryrun/
   64  ls
   65  sudo vagrant ssh
```
