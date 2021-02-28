#!/bin/sh
# cd7db00c-fff0-4c94-8448-312061ee44d8 - Centos 7
# 3672370a-af54-47c2-b2c1-d9875952415f - Ubuntu 16.04 Xenial

show_help() {
    echo -e \
"Usage: stack-control.sh [-l] [-r <stack>] [-sd [-i image_id] <stack>]\n"\
"l - list the current stacks\n"\
"r - deletes the specified stack\n"\
"s - creates a stack with storage nodes with the specified name\n"\
"d - creates a default 2-node stack with the specified name"
}

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
cmd=""
stackfile=""
imageid=""

while getopts "h?rsdli:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    r)
        cmd="delete"
        ;;
    s)
        cmd="create"
        stackfile="storage_stack.yaml"
        ;;
    d)
        cmd="create"
        stackfile="default_stack.yaml"
        ;;
    l)
        cmd="list"
        ;;
    i)
        imageid="$OPTARG"
        ;;
    esac
done

shift $((OPTIND-1))

[ "${1:-}" = "--" ] && shift

stackname=$@

if [ "$cmd" != "list" -a -z "$stackname" ] ; then
    show_help
    exit 1
fi

case "$cmd" in
    create)
        if [ -z imageid ] ; then
            openstack stack create -t "$stackfile" "$stackname"
        else
            openstack stack create --parameter image_id="$imageid" -t "$stackfile" "$stackname"
        fi
        exit 0
        ;;
    delete)
        openstack stack delete $stackname
        exit 0
        ;;
    list)
        openstack stack list
        exit 0
        ;;
    *)
        show_help
        exit 1
        ;;
esac