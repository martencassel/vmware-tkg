#!/bin/bash

#
# Upgrade TKG from 2.1.x to 2.2.0
#

#
# Setup Tanzu CLI for 2.2.0
#
TKG_VERSION="2.2.0"
KUBECTL_FILE="kubectl-linux-v1.25.7+vmware.2.gz"
#OVA_FILE="photon-3-kube-v1.25.7+vmware.2-tkg.1-8795debf8031d8e671660af83b673daa.ova"
OVA_FILE=""
../tkg/bin/prepare-tkg.sh $TKG_VERSION $KUBECTL_FILE $OVA_FILE

# Verify that Tanzu CLI and kubectl are installed and has the correct version
./tanzu version
./kubectl version --short

# Check that the OVA file for the management cluster is uploaded to vSphere
../tkg/bin/get-tkg-files.sh $TKG_VERSION|grep "photon-3-kube-v1.25.7+vmware.2-tkg.1-8795debf8031d8e671660af83b673daa.ova"

#
# Check versions before upgrade
#
tanzu cluster list --include-management-cluster -A

# Start the upgrade

# Get kubeconfig for management cluster
tanzu mc kubeconfig get --admin
kubectl config use-context CLUSTER-NAME-admin@CLUSTER-NAME.

# Upgrade the management cluster
tanzu mc upgrade

# Verify the upgrade
tanzu cluster list --include-management-cluster -A

kubectl get nodes -A
kubectl get cluster -A