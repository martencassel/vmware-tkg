#!/bin/bash

TKG_VERSION="2.2.0"
KUBECTL_FILE="kubectl-linux-v1.25.7+vmware.2.gz"

#OVA_FILE="photon-3-kube-v1.25.7+vmware.2-tkg.1-8795debf8031d8e671660af83b673daa.ova"
OVA_FILE=""

# Check all parameters are set
if [ -z "$TKG_VERSION" ] || [ -z "$KUBECTL_FILE" ] ; then
    echo "Please set all parameters TKG_VERSION, KUBECTL_FILE"
    exit 1
fi

# Write a message that we are setting up the environment for TKG $TKG_VERSION
echo "Setting up the environment for TKG $TKG_VERSION"

#
# Setup CLI
#
./tkg/bin/get-tkg-files.sh $TKG_VERSION
./tkg/bin/get-tanzu-cli.sh $TKG_VERSION
./tkg/bin/get-tkg-files.sh $TKG_VERSION

./tkg/bin/get-tkg-file.sh $TKG_VERSION "$KUBECTL_FILE.gz" $KUBECTL_FILE
ln -s $KUBECTL_FILE ./kubectl

echo "Now you can use the following commands in your local folder:"
./tanzu version --short
./kubectl version --short

#
# Download OVF image
#
# If variable is set, download the OVA file
if [ ! -z "$OVA_FILE" ]; then
    ./tkg/bin/get-tkg-files.sh $TKG_VERSION
    ./tkg/bin/get-tkg-file.sh $TKG_VERSION $OVA_FILE $OVA_FILE
    # Upload to vSphere Folder
    mv -f $OVA_FILE /mnt/c/Users/semca/
    echo "Open browser and upload OVF to vsphere folder, dont forget to convert to template"
fi

