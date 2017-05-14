#!/usr/bin/env bash

# Initialization
CA_KEY_FILE="${SCM_DOCKER_1_DATA_CERTS_DIR}/ca.key"
CA_CRT_FILE="${SCM_DOCKER_1_DATA_CERTS_DIR}/ca.crt"
CA_SRL_FILE="${SCM_DOCKER_1_DATA_CERTS_DIR}/ca.srl"
REGISTRY_KEY_FILE="${SCM_DOCKER_1_DATA_CERTS_DIR}/registry.key"
REGISTRY_CRT_FILE="${SCM_DOCKER_1_DATA_CERTS_DIR}/registry.crt"

echo "> Removing certificates:"

# Docker Registry certificate file does exist ?
if [ -f "${REGISTRY_CRT_FILE}" ]
then
	echo ">> Removing Docker Registry certificate..."
	rm -f "${REGISTRY_CRT_FILE}"
else
	echo ">> Docker Registry certificate file does not exists."
fi

# Docker Registry key file does exist ?
if [ -f "${REGISTRY_KEY_FILE}" ]
then
	echo ">> Removing Docker Registry key..."
	rm -f "${REGISTRY_KEY_FILE}"
else
	echo ">> Docker Registry key file does not exists."
fi

# CA certificate file does exist ?
if [ -f "${CA_CRT_FILE}" ]
then
	echo ">> Removing CA certificate..."
	rm -f "${CA_CRT_FILE}"
else
	echo ">> CA certificate file does not exists."
fi

# CA key file does exist ?
if [ -f "${CA_KEY_FILE}" ]
then
	echo ">> Removing CA key..."
	rm -f "${CA_KEY_FILE}"
else
	echo ">> CA key file does not exists."
fi

# CA serial file does exist ?
if [ -f "${CA_SRL_FILE}" ]
then
	echo ">> Removing CA serial file..."
	rm -f "${CA_SRL_FILE}"
else
	echo ">> CA serial file does not exists."
fi

echo "> Certificates removed."
echo

