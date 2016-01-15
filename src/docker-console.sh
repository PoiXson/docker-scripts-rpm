#!/bin/bash
clear
source /usr/bin/docker-scripts/docker-common.sh




if [ ! -f /etc/docker-scripts.conf ]; then
	echo '/etc/docker-scripts.conf file not found!'
	exit 1
fi
source /etc/docker-scripts.conf



if [ -z $1 ]; then
	echo "Usage: $0 <container_name>"
fi
NAME_ARG="${1}"



CONTAINER_NAME=''
CONTAINER_ID=''
function get_container_info() {
	if [ -z $DOCKER_IMAGE_ORG ]; then
		CONTAINER_NAME="${NAME_ARG}"
	else
		CONTAINER_NAME="${DOCKER_IMAGE_ORG}/${NAME_ARG}"
	fi
	CONTAINER_ID=`docker ps -f ancestor="${CONTAINER_NAME}" | tail -n +2 | awk '{print $1}'`
	if [ -z $CONTAINER_ID ]; then
		errcho "Container not found or not running: ${CONTAINER_NAME}"
		exit 1
	fi
}
get_container_info
echo
echo 'Consoling container..'
echo "Name: ${CONTAINER_NAME}"
echo "id:   ${CONTAINER_ID}"
echo



docker exec -it "${CONTAINER_ID}" /bin/bash
