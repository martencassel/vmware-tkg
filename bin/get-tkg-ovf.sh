#!/bin/bash
TKG_VERSION=$1
FILE_PATTERN=$2
# Print usage if no arguments are provided
if [ -z "$TKG_VERSION" ] || [ -z "$FILE_PATTERN" ]; then
  echo "Usage: $0 <TKG_VERSION> <FILE_PATTERN>"
  exit 1
fi
VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
VCC_SUBPRODUCT="tkg"
VCC_VERSION=$TKG_VERSION
./get-vcc-files.sh $VCC_PRODUCT $VCC_SUBPRODUCT $VCC_VERSION|grep $FILE_PATTERN|grep -v tiny|grep -v fips|grep -v harbor|grep -v haproxy