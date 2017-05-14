#!/usr/bin/env bash

# Initialization
CA_KEY_FILE="${SCM_DOCKER_1_DATA_CERTS_DIR}/ca.key"
CA_CRT_FILE="${SCM_DOCKER_1_DATA_CERTS_DIR}/ca.crt"
REGISTRY_KEY_FILE="${SCM_DOCKER_1_DATA_CERTS_DIR}/registry.key"
REGISTRY_CSR_FILE="${SCM_DOCKER_1_DATA_CERTS_DIR}/registry.csr"
REGISTRY_CRT_FILE="${SCM_DOCKER_1_DATA_CERTS_DIR}/registry.crt"

echo "> Creating certificates:"

# CA key file does not yet exist ?
if [ ! -f "${CA_KEY_FILE}" ]
then
	echo ">> Generating CA key..."
	openssl genrsa -aes256 -out "${CA_KEY_FILE}" 4096

	# Prevent unauthorized access to the CA key file
	chmod 0400 "${CA_KEY_FILE}"
	echo
else
	echo ">>CA key file already exists."
fi

# CA certificate file does not yet exist ?
if [ ! -f "${CA_CRT_FILE}" ]
then
	echo ">> Generating CA certificate..."
	openssl req -new -x509 -sha256 -days 3650 -subj "/CN=ca" -key "${CA_KEY_FILE}" -out "${CA_CRT_FILE}"

	# Prevent unauthorized access to the CA certificate file
	chmod 0444 "${CA_CRT_FILE}"
	echo
else
	echo ">> CA certificate file already exists."
fi

# Docker Registry key file does not yet exist ?
if [ ! -f "${REGISTRY_KEY_FILE}" ]
then
	echo ">> Generating Docker Registry key..."
	openssl genrsa -out "${REGISTRY_KEY_FILE}" 4096

	# Prevent unauthorized access to the Docker Registry key file
	chmod 0400 "${REGISTRY_KEY_FILE}"
	echo
else
	echo ">> Docker Registry key file already exists."
fi

# Docker Registry certificate file does not yet exist ?
if [ ! -f "${REGISTRY_CRT_FILE}" ]
then
	echo ">> Generating Docker Registry certificate..."
	openssl req -new -sha256 -subj "/CN=registry" -key "${REGISTRY_KEY_FILE}" -out "${REGISTRY_CSR_FILE}"

	echo ">> Signing Docker Registry certificate..."
	openssl x509 -req -sha256 -days 3650 -in "${REGISTRY_CSR_FILE}" -CA "${CA_CRT_FILE}" -CAkey "${CA_KEY_FILE}" -CAcreateserial -out "${REGISTRY_CRT_FILE}"

	# Prevent unauthorized access to the Docker Registry key file
	chmod 0444 "${REGISTRY_CRT_FILE}"

	# Remove signing request file
	rm "${REGISTRY_CSR_FILE}"
else
	echo ">> Docker Registry certificate already exists."
fi

echo "> Certificates created."
echo
