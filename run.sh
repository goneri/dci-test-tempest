#!/bin/sh

mkdir tempest
(
    source overcloudrc
    cd tempest
    /usr/share/openstack-tempest-liberty/tools/configure-tempest-directory
    tools/config_tempest.py --deployer-input ~/tempest-deployer-input.conf --debug --create identity.uri $OS_AUTH_URL identity.admin_password $OS_PASSWORD object-storage-feature-enabled.discoverability False
    # tools/run-tests.sh .*smoke
    tools/run-tests.sh
)
ls -l tempest/tempest.xml tempest/tempest.log
cp tempest/tempest.xml result.xml
