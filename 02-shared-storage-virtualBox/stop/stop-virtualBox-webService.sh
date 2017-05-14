#!/usr/bin/env bash

# Set name of directory to store pid and logging of VirtualBox web service
LOG_DIR="${SCM_DOCKER_1_DATA_DIR}/vbox/websrv"

# Set name of the file containing the pid of the VirtualBox web service
PID_FILE_NAME="${LOG_DIR}/vboxwebsrv.pid"

if [ -e "${PID_FILE_NAME}" ]
then
	echo "> Stopping VirtualBox web service..."

	PID=`cat ${PID_FILE_NAME}`
	kill ${PID}
	rm ${LOG_DIR}/*

	echo "> VirtualBox web service stopped."
else
	echo "> VirtualBox web service is not running."
fi
echo
