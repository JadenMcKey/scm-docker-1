#!/usr/bin/env bash

# Validate that environment is set
if [ -z "${SCM_DOCKER_1_APPL_DIR}" ]
then
	echo "ERROR: Environment not set !"
	echo
	exit 1
fi

${SCM_DOCKER_1_APPL_DOCKER_CONTAINERS_DIR}/remove/remove-docker-containers-all.sh && \
${SCM_DOCKER_1_APPL_DOCKER_SERVICES_DIR}/remove/remove-docker-services-all.sh     && \
${SCM_DOCKER_1_APPL_DOCKER_REGISTRY_DIR}/remove/remove-docker-service-registry.sh && \
${SCM_DOCKER_1_APPL_DOCKER_VOLUMES_DIR}/remove/remove-docker-volumes.sh           && \
${SCM_DOCKER_1_APPL_DOCKER_HOSTS_DIR}/stop/stop-docker-hosts.sh                   && \
${SCM_DOCKER_1_APPL_SHARED_STORAGE_DIR}/stop/stop-virtualBox-webService.sh        && \
${SCM_DOCKER_1_APPL_DOCKER_HOSTS_DIR}/remove/remove-docker-hosts.sh               && \
${SCM_DOCKER_1_APPL_CERTIFICATES_DIR}/remove/remove-certificates.sh

