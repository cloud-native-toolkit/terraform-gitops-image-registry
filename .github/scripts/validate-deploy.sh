#!/usr/bin/env bash

GIT_REPO=$(cat git_repo)
GIT_TOKEN=$(cat git_token)

export KUBECONFIG=$(cat .kubeconfig)
NAMESPACE=$(cat .namespace)
BRANCH="main"
SERVER_NAME="default"

COMPONENT_NAME="image-registry"

mkdir -p .testrepo

git clone https://${GIT_TOKEN}@${GIT_REPO} .testrepo

cd .testrepo || exit 1

find . -name "*"

if [[ ! -f "argocd/1-infrastructure/cluster/${SERVER_NAME}/base/${NAMESPACE}-${COMPONENT_NAME}.yaml" ]]; then
  echo "ArgoCD config missing - argocd/1-infrastructure/cluster/${SERVER_NAME}/base/${NAMESPACE}-${COMPONENT_NAME}.yaml"
  exit 1
fi

echo "Printing argocd/1-infrastructure/cluster/${SERVER_NAME}/base/${NAMESPACE}-${COMPONENT_NAME}.yaml"
cat "argocd/1-infrastructure/cluster/${SERVER_NAME}/base/${NAMESPACE}-${COMPONENT_NAME}.yaml"

if [[ ! -f "payload/1-infrastructure/namespace/${NAMESPACE}/${COMPONENT_NAME}/registry-config.yaml" ]]; then
  echo "Registry config values not found - payload/1-infrastructure/namespace/${NAMESPACE}/${COMPONENT_NAME}/registry-config.yaml"
  exit 1
fi

echo "Printing payload/1-infrastructure/namespace/${NAMESPACE}/${COMPONENT_NAME}/registry-config.yaml"
cat "payload/1-infrastructure/namespace/${NAMESPACE}/${COMPONENT_NAME}/registry-config.yaml"

if [[ ! -f "payload/1-infrastructure/namespace/${NAMESPACE}/${COMPONENT_NAME}/registry-access.yaml" ]]; then
  echo "Registry secret values not found - payload/1-infrastructure/namespace/${NAMESPACE}/${COMPONENT_NAME}/registry-access.yaml"
  exit 1
fi

echo "Printing payload/1-infrastructure/namespace/${NAMESPACE}/${COMPONENT_NAME}/registry-access.yaml"
cat "payload/1-infrastructure/namespace/${NAMESPACE}/${COMPONENT_NAME}/registry-access.yaml"

count=0
until kubectl get namespace "${NAMESPACE}" 1> /dev/null 2> /dev/null || [[ $count -eq 20 ]]; do
  echo "Waiting for namespace: ${NAMESPACE}"
  count=$((count + 1))
  sleep 15
done

if [[ $count -eq 20 ]]; then
  echo "Timed out waiting for namespace: ${NAMESPACE}"
  exit 1
else
  echo "Found namespace: ${NAMESPACE}. Sleeping for 30 seconds to wait for everything to settle down"
  sleep 30
fi

count=0
until kubectl get configmap "registry-config" -n "${NAMESPACE}" || [[ $count -eq 20 ]]; do
  echo "Waiting for configmap/registry-config in ${NAMESPACE}"
  count=$((count + 1))
  sleep 15
done

if [[ $count -eq 20 ]]; then
  echo "Timed out waiting for configmap/registry-config in ${NAMESPACE}"
  kubectl get all,configmap,secret -n "${NAMESPACE}"
  exit 1
fi

cd ..
rm -rf .testrepo
