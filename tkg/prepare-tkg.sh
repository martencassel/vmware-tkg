#!/bin/bash

TKG_VERSION=$1
KUBECTL_FILE=$2
OVA_FILE=$3

# Check all parameters are set
if [ -z "$TKG_VERSION" ] || [ -z "$KUBECTL_FILE" ] ; then
    echo "Please set all parameters TKG_VERSION, KUBECTL_FILE"
    exit 1
fi

# Check that internet is available
if ! ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
    echo "No internet connection available"
    exit 1
fi

# Write a message that we are setting up the environment for TKG $TKG_VERSION
echo "Setting up the environment for TKG $TKG_VERSION"

echo "Deleting  ~/.config/tanzu/tkg/compatibility/tkg-compatibility.yaml if it exists"
rm -f ~/.config/tanzu/tkg/compatibility/tkg-compatibility.yaml

#
# Setup CLI
#
./bin/get-tkg-files.sh $TKG_VERSION
./bin/get-tanzu-cli.sh $TKG_VERSION
./bin/get-tkg-files.sh $TKG_VERSION

./bin/get-tkg-file.sh $TKG_VERSION "$KUBECTL_FILE.gz" $KUBECTL_FILE
ln -s $KUBECTL_FILE ./kubectl

echo "Now you can use the following commands in your local folder:"
./tanzu version --short
./kubectl version --short

#
# Download OVF image, this is optional.
#

# If variable is set, download the OVA file otherwise skip.
if [ ! -z "$OVA_FILE" ]; then
    ./bin/get-tkg-files.sh $TKG_VERSION
    ./bin/get-tkg-file.sh $TKG_VERSION $OVA_FILE $OVA_FILE
    # Upload to vSphere Folder
    mv -f $OVA_FILE /mnt/c/Users/semca/
    echo "Open browser and upload OVF to vsphere folder, dont forget to convert to template"
fi





