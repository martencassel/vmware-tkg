#!/bin/bash

TKG_VERSION="2.1.1"
KUBECTL_FILE="kubectl-linux-v1.24.9+vmware.1.gz"
#OVA_FILE="photon-3-kube-v1.24.10+vmware.1-tkg.1-fbb49de6d1bf1f05a1c3711dea8b9330.ova"
OVA_FILE=""

./prepare-tkg.sh $TKG_VERSION $KUBECTL_FILE $OVA_FILE

# Check we have tanzu cli and kubectl
./tanzu version --short
./kubectl version --short

# Install Tanzu CLI
./tanzu init
./tanzu version
./tanzu plugin clean
./tanzu plugin sync
./tanzu plugin list

# Start installer ui, enter configuration values and export the configuration file.
./tanzu mc create --ui

# Start the installer using the configuration file
./tanzu mc create --file <configuration-file>

# Check the status of the installation
./tanzu mc get

# Get the kubeconfig file
./tanzu mc kubeconfig get <management-cluster-name> --admin

# List the management clusters
./tanzu cluster list -A --include-management-cluster



