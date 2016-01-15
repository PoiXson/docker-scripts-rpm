#!/bin/bash

source /usr/bin/shellscripts/common.sh
PWD=`pwd`


# load config
if [ ! -f /etc/docker-scripts.conf ]; then
	echo '/etc/docker-scripts.conf file not found!'
	exit 1
fi
source /etc/docker-scripts.conf
if [ -z $DOCKER_ORG ]; then
	echo 'DOCKER_ORG value not set in docker-scripts.conf config file!'
	exit 1
fi
