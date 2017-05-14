#!/bin/sh

set -e

LABELS="${LABELS:-docker}"
EXECUTORS="${EXECUTORS:-2}"
FSROOT="${FSROOT:-/tmp}"

mkdir -p ${FSROOT}
java -jar swarm-client.jar \
     -labels=${LABELS} \
     -executors=${EXECUTORS} \
     -fsroot=${FSROOT} \
     -name=docker-$(hostname) \
      $(cat /run/secrets/jenkins)
