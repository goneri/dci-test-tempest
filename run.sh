#!/bin/bash
set -eux
sudo yum install -y openstack-tempest-liberty python-tempest-lib

[ -d tempest ] || mkdir tempest

source overcloudrc
cd tempest
/usr/share/openstack-tempest-liberty/tools/configure-tempest-directory
tools/config_tempest.py --deployer-input ~/tempest-deployer-input.conf --debug --create identity.uri $OS_AUTH_URL identity.admin_password $OS_PASSWORD object-storage-feature-enabled.discoverability False

[ -d .testrepository ] || testr init
testr run --subunit |  subunit2junitxml --output-to=../result.xml
