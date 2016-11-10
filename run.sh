#!/bin/bash

osp_version=$(yum info rhosp-director-images 2>&1|awk '/Version/ {print $3}')
case $osp_version in
    '8.0')
    sudo yum install -y openstack-tempest-liberty python-tempest-lib
    # do not test manila
    sudo yum remove -y openstack-rally python-manila
    tempest_dir='/usr/share/openstack-tempest-liberty'
    ;;
    '9.0')
    sudo yum install -y openstack-tempest
    tempest_dir='/usr/share/openstack-tempest-10.0.0'
    ;;
esac

[ -d tempest ] || mkdir tempest

source ~/${DCI_OVERCLOUD_STACK_NAME}rc
cd tempest

${tempest_dir}/tools/configure-tempest-directory
tools/config_tempest.py --deployer-input ~/tempest-deployer-input.conf --debug --create identity.uri $OS_AUTH_URL identity.admin_password $OS_PASSWORD object-storage-feature-enabled.discoverability False

[ -d .testrepository ] || testr init
testr run --subunit --parallel --concurrency=4 '.*smoke.*' |subunit2junitxml --output-to=../result.xml
echo 'done'
exit 0
