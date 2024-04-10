#!/bin/bash
OVF_FILE=$1
VCENTER_HOST=$2
CLUSTER=$3
FOLDER=$4
USER=$5
PASSWORD=$6
if [ -z "$OVF_FILE" ] || [ -z "$VCENTER_HOST" ] || [ -z "$CLUSTER" ] || [ -z "$FOLDER" ] || [ -z "$USER" ] || [ -z "$PASSWORD" ]; then
  echo "Usage: $0 <ovf-file> <vcenter-host> <cluster> <folder> <user> <password>"
  exit 1
fi

# Check if the ovftool binary is available in the PATH
if ! command -v ovftool &> /dev/null
then
    echo "ovftool could not be found"
    echo "Please download and install ovftool from https://developer.vmware.com/web/tool/4.3.0/ovf"
    exit 1
fi


# Upload the OVF file to the vCenter
ovftool --X:logFile=ovftool.log --X:logLevel=verbose --X:logToConsole --acceptAllEulas --noSSLVerify --name=ovf-test --datastore=datastore1 --network="VM Network" --diskMode=thin --prop:password=$PASSWORD --prop:user=$USER $OVF_FILE "vi://$USER:$PASSWORD@$VCENTER_HOST/$CLUSTER/host/$CLUSTER/$FOLDER"

