#
# Copyright (c) 2018-2020 by Kristoffer Paulsson <kristoffer.paulsson@talenten.se>.
#
# This software is available under the terms of the MIT license. Parts are licensed under
# different terms if stated. The legal terms are attached to the LICENSE file and are
# made available on:
#
#     https://opensource.org/licenses/MIT
#
# SPDX-License-Identifier: MIT
#
# Contributors:
#     Kristoffer Paulsson - initial implementation
#

Vagrant.configure("2") do |config|
  config.vm.box = "generic/debian10"
  config.vm.synced_folder "data", "/home/vagrant/data", type: "virtualbox"
  config.vm.provision "shell", privileged: false, inline: <<-SHELL

    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install build-essential devscripts debhelper \
    nano git python3 python3-pip python3-virtualenv curl -y
    sudo apt-get install zlib1g-dev libncurses5-dev libgdbm-dev \
    libnss3-dev libssl-dev libreadline-dev libffi-dev libbz2-dev \
    libsqlite3-dev -y

    python3 -m virtualenv venv -p /usr/bin/python3
    source venv/bin/activate

    if cd angelos > /dev/null 2&>1
    then
      git pull
    else
      git clone https://github.com/kristoffer-paulsson/angelos.git angelos
      cd angelos
    fi

    if [ -s "/home/vagrant/data/libsodium-1.0.18.tar.gz" ]
    then
      ln -sf /home/vagrant/data/libsodium-1.0.18.tar.gz ./angelos-bin/tarball/libsodium-1.0.18.tar.gz
    fi

    if [ -s "/home/vagrant/data/Python-3.8.5.tgz" ]
    then
      ln -sf /home/vagrant/data/Python-3.8.5.tgz ./angelos-server/tarball/Python-3.8.5.tgz
    fi

    pip install pip --upgrade
    pip install setuptools --upgrade
    pip install wheel --upgrade
    pip install -r requirements.txt
    pip install -e .

    sudo mkdir /opt/angelos -p
    sudo chown vagrant:vagrant /opt/angelos
    python setup.py venv --prefix=/opt/angelos 2>&1 | tee -a venv.log
    mv venv.log /home/vagrant/data

    sudo chmod +x angelos-meta/bin/angelos-filter-files
    sudo chmod +x angelos-meta/bin/angelos-deb-control
    sudo chmod +x angelos-meta/bin/angelos-render-file
    sudo chmod +x angelos-meta/bin/angelos-render-script

    angelos-meta/bin/angelos-filter-files

    PACKAGE=$(angelos-meta/bin/angelos-deb-control -r=name -l=0)
    mkdir $PACKAGE/DEBIAN/ -p
    angelos-meta/bin/angelos-deb-control -r=control > $PACKAGE/DEBIAN/control

    angelos-meta/bin/angelos-render-script -r=pre-inst -s=debian > $PACKAGE/DEBIAN/preinst
    angelos-meta/bin/angelos-render-script -r=post-inst -s=debian > $PACKAGE/DEBIAN/postinst
    angelos-meta/bin/angelos-render-script -r=pre-rem -s=debian > $PACKAGE/DEBIAN/prerm
    angelos-meta/bin/angelos-render-script -r=post-rem -s=debian > $PACKAGE/DEBIAN/postrm

    sudo chmod 775 $PACKAGE/DEBIAN/*

    mkdir $PACKAGE/opt -p
    sudo mv /opt/angelos/ $PACKAGE/opt

    install --directory $PACKAGE/etc/angelos
    install --directory -m 700 $PACKAGE/var/lib/angelos
    install --directory -m 700 $PACKAGE/var/log/angelos

    install -D -m 0644 <(angelos-meta/bin/angelos-render-file -r=env) $PACKAGE/etc/angelos/env.json
    install -D -m 0644 <(angelos-meta/bin/angelos-render-file -r=config) $PACKAGE/etc/angelos/config.json
    install -D -m 600 <(angelos-meta/bin/angelos-render-file -r=admins) $PACKAGE/var/lib/angelos/admins.pub
    install -D -m 0644 <(angelos-meta/bin/angelos-render-file -r=service) $PACKAGE/usr/lib/systemd/system/angelos.service

    dpkg-deb --build $PACKAGE 2>&1 | tee -a ../build.log

    mv ../build.log /home/vagrant/data
    mv ./$PACKAGE.deb /home/vagrant/data

    deactivate
  SHELL
end