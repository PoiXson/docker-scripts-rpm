#!/bin/bash
source /usr/bin/docker-scripts/docker-common.sh



IMAGE_NAME=''
IMAGE_VERSION=''
IMAGE_ORGNAME=''
IMAGE_ORGNAMETAG=''
function get_build_info() {
	if [ ! -f "${PWD}/Dockerfile" ]; then
		errcho 'Dockerfile not found in current directory!'
		exit 1
	fi
	# get comments from Dockerfile
	while read LINE; do
		if [[ $LINE != "# "* ]]; then
			break
		fi
		# name:
		if [[ $LINE == "# name: "* ]]; then
			IMAGE_NAME=`echo "${LINE}" | rev | cut -d: -f1 | rev | xargs`
		elif [[ $LINE == "# version: "* ]]; then
			IMAGE_VERSION=`echo "${LINE}" | rev | cut -d: -f1 | rev | xargs`
		fi
	done < "${PWD}/Dockerfile"
	if [ -z $IMAGE_NAME ]; then
		IMAGE_NAME=`echo "${PWD}" | rev | cut -d/ -f1 | rev | xargs`
	fi
	if [ -z $IMAGE_NAME ]; then
		echo 'Failed to find a name for the image!'
		exit 1
	fi
	if [ -z $IMAGE_VERSION ]; then
		echo 'Failed to find image version from Dockerfile!'
		exit 1
	fi
	IMAGE_ORGNAME="${DOCKER_IMAGE_ORG}/${IMAGE_NAME}"
	IMAGE_ORGNAMETAG="${IMAGE_ORGNAME}:${IMAGE_VERSION}"
	title "Creating Docker Image" "${IMAGE_ORGNAMETAG}"
#	title "Creating Docker Image" "${DOCKER_IMAGE_ORG} / ${IMAGE_NAME} : ${IMAGE_VERSION}"
}
get_build_info



docker build -t "${IMAGE_ORGNAMETAG}" "${PWD}/"
docker tag -f "${IMAGE_ORGNAMETAG}" "${IMAGE_NAME}:latest"
