#!/bin/bash
source /usr/bin/shellscripts/common.sh
PWD=`pwd`



# load config
if [ ! -f /etc/docker-scripts.conf ]; then
	errcho '/etc/docker-scripts.conf file not found!'
	exit 1
fi
source /etc/docker-scripts.conf
if [ -z $DOCKER_IMAGE_ORG ]; then
	errcho 'DOCKER_IMAGE_ORG value not set in docker-scripts.conf config file!'
	exit 1
fi
