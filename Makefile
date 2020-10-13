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

default:
	vagrant destroy -f && vagrant up 2>&1 | tee -a build.log && vagrant halt

clean:
	rm -fr ./data/*.spec
	rm -fr ./data/*.log
	rm -fr ./data/*.deb
	rm -fr ./*.log

ssh:
	vagrant up && vagrant ssh
