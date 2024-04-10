#!/bin/bash
rm -rf /tmp/tmp-output||true
VERSION=$1
if [ -z $VERSION ]; then
  echo "Usage: $0 <version>"
  exit 1
fi
JSON=$(vcc get files -p vmware_tanzu_kubernetes_grid -s tkg -v $VERSION --format json)
echo $JSON > /tmp/tmp-output
echo $JSON|jq -r ".files[].fileName"|grep -v -e "^$"
