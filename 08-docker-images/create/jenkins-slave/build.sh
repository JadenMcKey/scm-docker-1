#!/usr/bin/env bash

# Properties of our private Docker registry
DOCKER_REGISTRY="registry:5000"
DOCKER_REGISTRY_USER="admin"
DOCKER_REGISTRY_PASSWORD="admin123"

# Properties of our Docker image to be build
DOCKER_IMAGE_NAME=my/jenkins-swarm-client
DOCKER_IMAGE_TAG=1

# Ensure we use a Docker daemon running in a VirtualBox VM that proxies all
# DNS requests to the VirtualBox host (natdnshostresolver1 on); otherwise the
# docker commands will not be able to resolve the IP of the registry host
DOCKER_HOST_SCM=swarm-scm-1

# Execute next Docker commands against our suitable host
eval $(docker-machine env ${DOCKER_HOST_SCM}) && \

# Login to our private Docker registry
docker login \
  -u ${DOCKER_REGISTRY_USER} \
  -p ${DOCKER_REGISTRY_PASSWORD} \
     ${DOCKER_REGISTRY} && \

# Build our Docker image for the Jenkins Swarm clients
docker build -t ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} . && \

# Upload image to our private Docker registry
docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}
