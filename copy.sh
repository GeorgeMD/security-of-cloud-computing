#!/bin/bash

show_help() {
    echo -e "Usage: ./copy.sh -c controller_ip -n compute_ip [-f file] [-d directory]"
}

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.
directory=""
file=""
controller=""
compute=""

# parse args
while getopts "c:n:d:f:" opt; do
    case "$opt" in
    c)
        controller="$OPTARG"
        ;;
    n)
        compute="$OPTARG"
        ;;
    d)
        directory="$OPTARG"
        ;;
    f)
        file="$OPTARG"
        ;;
    esac
done

if [ -z $controller ]; then
    echo "controller_ip is required"
    exit 1
fi

if [ -z $compute ]; then
    echo "compute_ip is required"
    exit 1
fi

if [ $file ]; then
    scp -i ~/.ssh/openstack $file centos@$controller:
    scp -i ~/.ssh/openstack $file centos@$compute:
fi

if [ $directory ]; then
    scp -ri ~/.ssh/openstack $directory centos@$controller:
    scp -ri ~/.ssh/openstack $directory centos@$compute:
fi
