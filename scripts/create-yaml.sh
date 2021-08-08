#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
MODULE_DIR=$(cd "${SCRIPT_DIR}/.."; pwd -P)

REGISTRY_URL="$1"
REGISTRY_NAMESPACE="$2"
DISPLAY_NAME="$3"
DEST_DIR="$4"

if [[ -z "${TMP_DIR}" ]]; then
  TMP_DIR=".tmp"
fi
mkdir -p "${TMP_DIR}"
mkdir -p "${DEST_DIR}"

kubectl create configmap registry-config \
  --from-literal=url="${REGISTRY_URL}" \
  --from-literal=namespace="${REGISTRY_NAMESPACE}" \
  --dry-run=client \
  -o yaml | \
kubectl label --local=true -f - --dry-run=client -o yaml \
  group=cloud-native-toolkit \
  grouping=garage-cloud-native-toolkit \
  console-link.cloud-native-toolkit.dev/enabled=true | \
kubectl annotate --local=true -f - --dry-run=client -o yaml \
  console-link.cloud-native-toolkit.dev/imageUrl="${IMAGE_URL}" \
  console-link.cloud-native-toolkit.dev/displayName="${DISPLAY_NAME}" > "${DEST_DIR}/registry-config.yaml"

find "${DEST_DIR}" -name "*"
