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
  config.vm.synced_folder "debian", "/home/vagrant/debian", type: "virtualbox"
  config.vm.provision "shell", privileged: false, inline: <<-SHELL

    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install build-essential nano git python3 python3-pip python3-virtualenv curl -y
    sudo apt-get install zlib1g-dev libncurses5-dev libgdbm-dev \
    libnss3-dev libssl-dev libreadline-dev libffi-dev libbz2-dev \
    libsqlite3-dev -y

    # pip3 install virtualenv

    git clone https://github.com/kristoffer-paulsson/angelos.git
    cd angelos

    python3 -m virtualenv venv -p /usr/bin/python3
    source venv/bin/activate
    pip install pip --upgrade
    pip install setuptools --upgrade
    pip install wheel --upgrade
    pip install -r requirements.txt
    pip install -e .

    sudo mkdir /opt/angelos -p
    sudo chown vagrant:vagrant /opt/angelos
    python setup.py venv --prefix=/opt/angelos

    deactivate

  SHELL
end