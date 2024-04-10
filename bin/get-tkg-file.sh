#!/bin/bash
VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
VCC_SUBPRODUCT="tkg"
VCC_VERSION=$1
VCC_FILE=$2
VCC_BUNDLE_FILE_PATH=$3
if [ -z $VCC_VERSION ] || [ -z $VCC_FILE ] || [ -z $VCC_BUNDLE_FILE_PATH ]; then
  echo "Usage: $0 <VCC_VERSION> <VCC_FILE> <VCC_BUNDLE_FILE_PATH>"
  exit 1
fi

echo "Downloading $VCC_PRODUCT $VCC_SUBPRODUCT $VCC_VERSION $VCC_FILE $VCC_BUNDLE_FILE_PATH"
# Create temporary directory
tmpdir=$(mktemp -d)
# Create temporary file in tmpdir
tmpfile=$(mktemp $tmpdir/tcli-XXXXX.yaml)
# Write to the temporary file
cat > $tmpfile <<EOF
---
product: $VCC_PRODUCT
subproduct: $VCC_SUBPRODUCT
version: "$VCC_VERSION"
filename_globs:
  - "$VCC_FILE"
EOF
vcc download -m $tmpfile -o $tmpdir -a
# List the files in the temporary directory
gzip -d $tmpdir/*.gz
ls -l $tmpdir

# Check if VCC_BUNDLE_FILE_PATH exists in the temporary directory
if [ -f $tmpdir/$VCC_BUNDLE_FILE_PATH ]; then
  echo "Copying $tmpdir/$VCC_BUNDLE_FILE_PATH to $VCC_BUNDLE_FILE_PATH"
  chmod u+x $tmpdir/$VCC_BUNDLE_FILE_PATH
  cp $tmpdir/$VCC_BUNDLE_FILE_PATH .
else
  echo "File $tmpdir/$VCC_BUNDLE_FILE_PATH not found"
  exit 1
fi

chmod u+x ./$VCC_BUNDLE_FILE_PATH
./$VCC_BUNDLE_FILE_PATH version --short
