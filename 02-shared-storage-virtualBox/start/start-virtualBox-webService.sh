#!/usr/bin/env bash

# Set name of directory to store pid and logging of VirtualBox web service
LOG_DIR="${SCM_DOCKER_1_DATA_DIR}/vbox/websrv"

# Set name of the file to contain the pid of the VirtualBox web service
PID_FILE_NAME="${LOG_DIR}/vboxwebsrv.pid"

# Set name of the file to contain the logging of the VirtualBox web service
LOG_FILE_NAME="${LOG_DIR}/vboxwebsrv.log"

# Create log directory (if it does not yet exist)
mkdir -p "${LOG_DIR}"

if [ ! -e "${PID_FILE_NAME}" ]
then
	echo "> Starting VirtualBox web service..."

	vboxmanage setproperty websrvauthlibrary null && \
	vboxwebsrv -b -P "${PID_FILE_NAME}" -F "${LOG_FILE_NAME}" -H 0.0.0.0

	echo "> VirtualBox web service started."
else
	echo "> VirtualBox web service is already running."
fi
echo
