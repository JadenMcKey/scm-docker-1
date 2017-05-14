#!/usr/bin/env bash

# Validate that environment is set
if [ -z "${SCM_DOCKER_1_APPL_DIR}" ]
then
	echo "ERROR: Environment not set !"
	echo
	exit 1
fi

${SCM_DOCKER_1_APPL_SHARED_STORAGE_DIR}/start/start-virtualBox-webService.sh      && \
${SCM_DOCKER_1_APPL_DOCKER_HOSTS_DIR}/start/start-docker-hosts.sh                 && \
${SCM_DOCKER_1_APPL_DOCKER_REGISTRY_DIR}/create/create-docker-service-registry.sh && \
${SCM_DOCKER_1_APPL_DOCKER_SERVICES_DIR}/create/create-docker-services-all.sh     && \
${SCM_DOCKER_1_APPL_DOCKER_CONTAINERS_DIR}/create/create-docker-containers-all.sh
