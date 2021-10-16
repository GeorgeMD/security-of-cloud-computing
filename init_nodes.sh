#!/bin/bash

yum update -y

dnf install -y vim net-tools

# install & enable PowerTools
dnf -y install dnf-plugins-core
dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
dnf config-manager --set-enabled powertools

# install OpenStack
dnf install -y centos-release-openstack-victoria
dnf install -y python3-openstackclient

# install & configure mariadb
dnf install -y mariadb-server
systemctl enable mariadb
systemctl start mariadb

# you MUST do this! on all nodes, no matter what, just DO IT
yum install openstack-selinux

# install node specific services
if [ "$NODE" == "controller" ] ; then
    yum install -y memcached python3-memcached

    systemctl enable memcached
    systemctl start memcached

    yum install -y rabbitmq-server

    yum install -y openstack-keystone httpd python3-mod_wsgi
fi

if [ "$NODE" == "compute" ] ; then
    # https://docs.openstack.org/placement/victoria/install/install-rdo.html
    # https://docs.openstack.org/nova/victoria/install/compute-install-rdo.html
fi

if [ "$NODE" == "storage" ] ; then
    # dnf install -y openstack-swift
fi


openstack subnet create --network provider \
  --allocation-pool start=10.9.254.100,end=10.9.254.105 \
  --dns-nameserver 141.85.241.15 --gateway 10.9.0.1 \
  --subnet-range 10.9.0.0/16 provider