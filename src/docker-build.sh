#!/bin/bash
clear

source /usr/bin/shellscripts/common.sh



PWD=`pwd`

if [ ! -f /etc/docker-scripts.conf ]; then
	echo '/etc/docker-scripts.conf file not found!'
	exit 1
fi
if [ ! -f "${PWD}/Dockerfile" ]; then
	errcho 'Dockerfile not found in current directory!'
	exit 1
fi

source /etc/docker-scripts.conf



NAME=''
IMAGE_NAME=''
IMAGE_NAME_TAG=''
IMAGE_VERSION='0.1.0'
function get_image_name() {
	# get name comment from file
	local line=$(head -n 1 "${PWD}/Dockerfile")
	if [[ $line == "# name: "* ]]; then
		NAME=`echo "${line}" | rev | cut -d: -f1 | rev | xargs`
	else
		NAME=`echo "${PWD}" | rev | cut -d/ -f1 | rev | xargs`
	fi
	if [ -z $NAME ]; then
		echo 'Failed to find a name for the image!'
		exit 1
	fi
	if [ -z $DOCKER_IMAGE_ORG ]; then
		IMAGE_NAME="${NAME}"
		IMAGE_NAME_TAG="${IMAGE_NAME}:${IMAGE_VERSION}"
	else
		IMAGE_NAME="${DOCKER_IMAGE_ORG}/${NAME}"
		IMAGE_NAME_TAG="${IMAGE_NAME}:${IMAGE_VERSION}"
	fi
}
get_image_name
echo
echo 'Creating docker image..'
if [ -z $DOCKER_IMAGE_ORG ]; then
	echo "${NAME} : ${IMAGE_VERSION}"
else
	echo "${DOCKER_IMAGE_ORG} / ${NAME} : ${IMAGE_VERSION}"
fi
echo



docker build -t "${IMAGE_NAME_TAG}" "${PWD}/"
docker tag -f "${IMAGE_NAME_TAG}" "${IMAGE_NAME}:latest"
