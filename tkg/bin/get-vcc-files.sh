#!/bin/bash
rm -rf /tmp/tmp-output||true
VCC_PRODUCT=$1
VCC_SUBPRODUCT=$2
VCC_VERSION=$3

if [ -z "$VCC_PRODUCT" ]; then
  echo "Usage: $0 <product> <subproduct> <version>"
  exit 1
fi

if [ -z "$VCC_SUBPRODUCT" ]; then
  echo "Usage: $0 <product> <subproduct> <version>"
  exit 1
fi

if [ -z "$VCC_VERSION" ]; then
  echo "Usage: $0 <product> <subproduct> <version>"
  exit 1
fi

JSON=$(vcc get files -p $VCC_PRODUCT -s $VCC_SUBPRODUCT -v $VCC_VERSION --format json)
echo $JSON > /tmp/tmp-output
echo $JSON|jq -r ".files[].fileName"|grep -v -e "^$"
