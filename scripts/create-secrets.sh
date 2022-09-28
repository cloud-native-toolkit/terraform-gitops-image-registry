#!/usr/bin/env bash

NAMESPACE="$1"
OUTPUT_DIR="$2"

NAME=$(echo "${SERVER}" | tr "." "-")

mkdir -p "${OUTPUT_DIR}"

kubectl create secret docker-registry -n "${NAMESPACE}" "${NAME}" \
  --docker-username="${USERNAME}" \
  --docker-password="${PASSWORD}" \
  --docker-server="${SERVER}" \
  --dry-run=client \
  -o yaml | \
kubectl label --local=true -f - --dry-run=client -o yaml \
   image-registry/push=true > "${OUTPUT_DIR}/${NAME}.yaml"

kubectl create secret generic -n "${NAMESPACE}" registry-access \
  --from-literal=REGISTRY_URL="${SERVER}" \
  --from-literal=REGISTRY_USER="${USERNAME}" \
  --from-literal=REGISTRY_PASSWORD="${PASSWORD}" \
  --from-literal=REGISTRY_NAMESPACE="${REGISTRY_NAMESPACE}" \
  --dry-run=client \
  -o yaml | \
kubectl label --local=true -f - --dry-run=client -o yaml \
  group=catalyst-tools \
  grouping=garage-cloud-native-toolkit > "${OUTPUT_DIR}/registry-access.yaml"
