#!/bin/sh
sudo yum install -y openstack-tempest-liberty python-tempest-lib
mkdir tempest

source overcloudrc
cd tempest
/usr/share/openstack-tempest-liberty/tools/configure-tempest-directory
tools/config_tempest.py --deployer-input ~/tempest-deployer-input.conf --debug --create identity.uri $OS_AUTH_URL identity.admin_password $OS_PASSWORD object-storage-feature-enabled.discoverability False

testr run | tee >( subunit2junitxml --output-to=result.xml ) | subunit-trace --no-failure-debug -f
