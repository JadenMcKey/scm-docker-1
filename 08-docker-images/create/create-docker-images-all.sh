#!/usr/bin/env bash

echo "> Creating Docker Images:"

# Store current working directory
OWD=$(pwd)

# Build Docker images for Jenkins Slave
cd "${SCM_DOCKER_1_APPL_DOCKER_IMAGES_DIR}/create/jenkins-slave" && ./build.sh

# Return to original working directory
cd "${OWD}"

echo "> Docker Images created."
echo
