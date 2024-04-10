#!/bin/bash
TKG_VERSION=$1

if [ -z "$TKG_VERSION" ]; then
  echo "Usage: $0 <tanzu-tkg-version>"
  exit 1
fi

# Make sure VCC_USER and VCC_PASS are set
if [ -z "$VCC_USER" ] || [ -z "$VCC_PASS" ]; then
  echo "Please set VCC_USER and VCC_PASS environment variables"
  exit 1
fi

# Check if vcc binary is available and in the PATH
function check_for_vcc_binary {
  if ! command -v vcc &> /dev/null; then
    echo "vcc binary not found in PATH"
    echo "Please download the vcc binary from https://github.com/vmware-labs/vmware-customer-connect-cli/releases/tag/v1.1.7"
    exit 1
  fi
}

function download_tanzu_cli {
  VCC_PRODUCT=$1
  VCC_SUBPRODUCT=$2
  VCC_VERSION=$3
  VCC_FILE=$4
  VCC_BUNDLE_FILE_PATH=$5
  # Download Tanzu CLI binary
  vcc_download $VCC_PRODUCT $VCC_SUBPRODUCT $VCC_VERSION $VCC_FILE $VCC_BUNDLE_FILE_PATH
  ls -l $(basename $VCC_BUNDLE_FILE_PATH)
  rm -f ./tanzu||true
  ln -s $(basename $VCC_BUNDLE_FILE_PATH) tanzu
  ./tanzu version
}

function download_kubectl_cli {
  VCC_PRODUCT=$1
  VCC_SUBPRODUCT=$2
  VCC_VERSION=$3
  VCC_FILE=$4
  VCC_BUNDLE_FILE_PATH=$5
  # Download Kubectl CLI binary
  vcc_download $VCC_PRODUCT $VCC_SUBPRODUCT $VCC_VERSION $VCC_FILE $VCC_BUNDLE_FILE_PATH
  ls -l $(basename $VCC_BUNDLE_FILE_PATH)
  rm -f ./kubectl||true
  ln -s $(basename $VCC_BUNDLE_FILE_PATH) kubectl
  ./kubectl version
}


check_for_vcc_binary

function vcc_download {
  VCC_PRODUCT=$1
  VCC_SUBPRODUCT=$2
  VCC_VERSION=$3
  VCC_FILE=$4
  VCC_BUNDLE_FILE_PATH=$5
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
  cat $tmpfile
  # Download the file
  vcc download -m $tmpfile -o $tmpdir -a
  # Print status
  echo "Downloaded $VCC_PRODUCT $VCC_SUBPRODUCT $VCC_VERSION $VCC_FILE"
  ls -lt $tmpdir
  # Check if expected file exists
  if [ ! -f $tmpdir/$VCC_FILE ]; then
    echo "Expected file $VCC_FILE not found in $tmpdir"
    exit 1
  fi
  # Determine filetype using file command
  if file $tmpdir/$VCC_FILE | grep -q "gzip compressed data"; then
    echo "File is a gzip compressed file"
    # Unzip the file
    gunzip $tmpdir/$VCC_FILE
    # Check if expected file exists
    if [ ! -f $tmpdir/${VCC_FILE%.gz} ]; then
      echo "Expected file ${VCC_FILE%.gz} not found in $tmpdir"
      exit 1
    fi
    # Remove .gz from VCC_FILE
    VCC_FILE=${VCC_FILE%.gz}
  fi
  if file $tmpdir/$VCC_FILE | grep -q "tar archive"; then
    echo "File is a tar archive"
    # Untar the file
    tar -xvf $tmpdir/$VCC_FILE -C $tmpdir
  else
    echo "Not a tar file"
  fi
  # Remove .tar suffix from VCC_FILE
  VCC_FILE=${VCC_FILE%.tar}
  ls -lt $tmpdir
  # Check that the expected file exists
  if [ ! -f $tmpdir/$VCC_BUNDLE_FILE_PATH ]; then
    echo "Expected file $VCC_BUNDLE_FILE_PATH not found in $tmpdir"
    exit 1
  else 
    echo "Found $VCC_BUNDLE_FILE_PATH in path $tmpdir/$VCC_BUNDLE_FILE_PATH"
  fi
  echo "Moving $tmpdir/$VCC_BUNDLE_FILE_PATH to current directory"
  mv $tmpdir/$VCC_BUNDLE_FILE_PATH .
  ls -l ./$(basename $VCC_BUNDLE_FILE_PATH)
  chmod +x ./$(basename $VCC_BUNDLE_FILE_PATH)
  ./$(basename $VCC_BUNDLE_FILE_PATH) version
  # Cleanup
  #rm -rf $tmpdir
}

# Declare variables
VCC_PRODUCT=""
VCC_SUBPRODUCT=""
VCC_VERSION=""

case $TKG_VERSION in
  1.0)
    VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
    VCC_SUBPRODUCT="tkg"
    VCC_VERSION="1.0"
    VCC_FILE="tkg-linux-amd64-v1.0.0_vmware.1.gz"
    VCC_BUNDLE_FILE_PATH="tkg-linux-amd64-v1.0.0_vmware.1"
    ;;
  1.1)
    VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
    VCC_SUBPRODUCT="tkg"
    VCC_VERSION="1.1"
    VCC_FILE="tkg-linux-amd64-v1.1.0-vmware.1.gz"
    VCC_BUNDLE_FILE_PATH="tkg-linux-amd64-v1.1.0-vmware.1"
    ;;
  1.1.2)
    VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
    VCC_SUBPRODUCT="tkg"
    VCC_VERSION="1.1.2"
    VCC_FILE="tkg-linux-amd64-v1.1.2-vmware.1.gz"
    VCC_BUNDLE_FILE_PATH="tkg-linux-amd64-v1.1.2-vmware.1"
    ;;
  1.1.3)
    VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
    VCC_SUBPRODUCT="tkg"
    VCC_VERSION="1.1.3"
    VCC_FILE="tkg-linux-amd64-v1.1.3_vmware.1.gz"
    VCC_BUNDLE_FILE_PATH="tkg-linux-amd64-v1.1.3_vmware.1"
    ;;
  1.2.0)
    VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
    VCC_SUBPRODUCT="tkg"
    VCC_VERSION="1.2.0"
    VCC_FILE="tkg-linux-amd64-v1.2.0-vmware.1.tar.gz"
    VCC_BUNDLE_FILE_PATH="tkg/tkg-linux-amd64-v1.2.0+vmware.1"
    ;;
  1.2.1)
    VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
    VCC_SUBPRODUCT="tkg"
    VCC_VERSION="1.2.1"
    VCC_FILE="tkg-linux-amd64-v1.2.1-vmware.1.tar.gz"
    VCC_BUNDLE_FILE_PATH="tkg/tkg-linux-amd64-v1.2.1+vmware.1"
    ;;
  1.3.0)
    VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
    VCC_SUBPRODUCT="tkg"
    VCC_VERSION="1.3.0"
    VCC_FILE="tanzu-cli-bundle-linux-amd64.tar"
    VCC_BUNDLE_FILE_PATH="cli/core/v1.3.0/tanzu-core-linux_amd64"
    ;;
  1.3.1)
    VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
    VCC_SUBPRODUCT="tkg"
    VCC_VERSION="1.3.1"
    VCC_FILE="tanzu-cli-bundle-v1.3.1-linux-amd64.tar"
    VCC_BUNDLE_FILE_PATH="cli/core/v1.3.0/tanzu-core-linux_amd64"
    ;;
  1.4.0)
    VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
    VCC_SUBPRODUCT="tkg"
    VCC_VERSION="1.4.0"
    VCC_FILE="tanzu-cli-bundle-linux-amd64.tar"
    VCC_BUNDLE_FILE_PATH="cli/core/v1.4.0/tanzu-core-linux_amd64"
    ;;
  1.4.1)
    VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
    VCC_SUBPRODUCT="tkg"
    VCC_VERSION="1.4.1"
    VCC_FILE="tanzu-cli-bundle-linux-amd64.tar"
    VCC_BUNDLE_FILE_PATH="cli/core/v1.4.1/tanzu-core-linux_amd64"
    ;;
  1.4.2)
    VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
    VCC_SUBPRODUCT="tkg"
    VCC_VERSION="1.4.2"
    VCC_FILE="tanzu-cli-bundle-linux-amd64.tar"
    VCC_BUNDLE_FILE_PATH="cli/core/v1.4.2/tanzu-core-linux_amd64"
    ;;
  1.4.3)
    VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
    VCC_SUBPRODUCT="tkg"
    VCC_VERSION="1.4.3"
    VCC_FILE="tanzu-cli-bundle-linux-amd64.tar"
    VCC_BUNDLE_FILE_PATH="cli/core/v1.4.3/tanzu-core-linux_amd64"
    ;;
  1.5.0)
    VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
    VCC_SUBPRODUCT="tkg"
    VCC_VERSION="1.5.0"
    VCC_FILE="tanzu-cli-bundle-linux-amd64.tar"
    VCC_BUNDLE_FILE_PATH="cli/core/v1.4.0/tanzu-core-linux_amd64"
    ;;
  1.5.1)
    VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
    VCC_SUBPRODUCT="tkg"
    VCC_VERSION="1.5.1"
    VCC_FILE="tanzu-cli-bundle-linux-amd64.tar.gz"
    VCC_BUNDLE_FILE_PATH="cli/core/v0.11.1/tanzu-core-linux_amd64"
    ;;
  1.5.2)
    VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
    VCC_SUBPRODUCT="tkg"
    VCC_VERSION="1.5.2"
    VCC_FILE="tanzu-cli-bundle-linux-amd64.tar.gz"
    VCC_BUNDLE_FILE_PATH="cli/core/v0.11.2/tanzu-core-linux_amd64"
    ;;
  1.5.3)
    VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
    VCC_SUBPRODUCT="tkg"
    VCC_VERSION="1.5.3"
    VCC_FILE="tanzu-cli-bundle-linux-amd64.tar.gz"
    VCC_BUNDLE_FILE_PATH="cli/core/v0.11.4/tanzu-core-linux_amd64"
    ;;
  1.5.4)
    VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
    VCC_SUBPRODUCT="tkg"
    VCC_VERSION="1.5.4"
    VCC_FILE="tanzu-cli-bundle-linux-amd64.tar.gz"
    VCC_BUNDLE_FILE_PATH="cli/core/v0.11.6/tanzu-core-linux_amd64"
    ;;
  1.6.0)
    VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
    VCC_SUBPRODUCT="tkg"
    VCC_VERSION="1.6.0"
    VCC_FILE="tanzu-cli-bundle-linux-amd64.tar.gz"
    VCC_BUNDLE_FILE_PATH="cli/core/v0.25.0/tanzu-core-linux_amd64"
    ;;
  1.6.1)
    VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
    VCC_SUBPRODUCT="tkg"
    VCC_VERSION="1.6.1"
    VCC_FILE="tanzu-cli-bundle-linux-amd64.tar.gz"
    VCC_BUNDLE_FILE_PATH="cli/core/v0.25.4/tanzu-core-linux_amd64"
    ;;
  2.1.0)
    VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
    VCC_SUBPRODUCT="tkg"
    VCC_VERSION="2.1.0"
    VCC_FILE="tanzu-cli-bundle-linux-amd64.tar.gz"
    VCC_BUNDLE_FILE_PATH="cli/core/v0.28.0/tanzu-core-linux_amd64"
    ;;
  2.1.1)
    VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
    VCC_SUBPRODUCT="tkg"
    VCC_VERSION="2.1.1"
    VCC_FILE="tanzu-cli-bundle-linux-amd64.tar.gz"
    VCC_BUNDLE_FILE_PATH="cli/core/v0.28.1/tanzu-core-linux_amd64"
    ./tkg/bin/get-tkg-file.sh 2.1.1 kubectl-linux-v1.24.10+vmware.1.gz kubectl-linux-v1.24.10+vmware.1
    ;;    
  2.2.0)
    VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
    VCC_SUBPRODUCT="tkg"
    VCC_VERSION="2.2.0"
    VCC_FILE="tanzu-cli-bundle-linux-amd64.tar.gz"
    VCC_BUNDLE_FILE_PATH="cli/core/v0.29.0/tanzu-core-linux_amd64"
    ;;    
  2.3.0)
    VCC_PRODUCT="vmware_tanzu_cli"
    VCC_SUBPRODUCT="tcli"
    VCC_VERSION="1.0.0"
    VCC_FILE="tanzu-cli-linux-amd64.tar.gz"
    VCC_BUNDLE_FILE_PATH="v1.0.0/tanzu-cli-linux_amd64"
    ;;    
  2.3.1)
    VCC_PRODUCT="vmware_tanzu_cli"
    VCC_SUBPRODUCT="tcli"
    VCC_VERSION="1.0.0"
    VCC_FILE="tanzu-cli-linux-amd64.tar.gz"
    VCC_BUNDLE_FILE_PATH="v1.0.0/tanzu-cli-linux_amd64"
    ;;    
  2.4.0)
    VCC_PRODUCT="vmware_tanzu_cli"
    VCC_SUBPRODUCT="tcli"
    VCC_VERSION="1.0.0"
    VCC_FILE="tanzu-cli-linux-amd64.tar.gz"
    VCC_BUNDLE_FILE_PATH="v1.0.0/tanzu-cli-linux_amd64"
    ;;    
  2.4.1)
    VCC_PRODUCT="vmware_tanzu_cli"
    VCC_SUBPRODUCT="tcli"
    VCC_VERSION="1.1.0"
    VCC_FILE="tanzu-cli-linux-amd64.tar.gz"
    VCC_BUNDLE_FILE_PATH="v1.1.0/tanzu-cli-linux_amd64"
    ;;    
  2.5.0)
    VCC_PRODUCT="vmware_tanzu_cli"
    VCC_SUBPRODUCT="tcli"
    VCC_VERSION="1.1.0"
    VCC_FILE="tanzu-cli-linux-amd64.tar.gz"
    VCC_BUNDLE_FILE_PATH="v1.1.0/tanzu-cli-linux_amd64"
    ;;    
  *)
    echo "Unsupported TKG version: $TKG_VERSION"
    exit 1
    ;;
esac

echo "VCC_PRODUCT: $VCC_PRODUCT"
echo "VCC_SUBPRODUCT: $VCC_SUBPRODUCT"
echo "VCC_VERSION: $VCC_VERSION"
echo "VCC_FILE: $VCC_FILE"

# CHeck if VCC_PRODUCT is set
if [ -z "$VCC_PRODUCT" ]; then
  echo "VCC_PRODUCT is not set"
  exit 1
fi
if [ -z "$VCC_SUBPRODUCT" ]; then
  echo "VCC_SUBPRODUCT is not set"
  exit 1
fi
if [ -z "$VCC_VERSION" ]; then
  echo "VCC_VERSION is not set"
  exit 1
fi
if [ -z "$VCC_FILE" ]; then
  echo "VCC_FILE is not set"
  exit 1
fi

# Download tanzu cli binary
download_tanzu_cli $VCC_PRODUCT $VCC_SUBPRODUCT $VCC_VERSION $VCC_FILE $VCC_BUNDLE_FILE_PATH

#Download kubectl binary
VCC_PRODUCT="vmware_tanzu_kubernetes_grid"
VCC_SUBPRODUCT="tkg"
VCC_VERSION="2.1.1"
VCC_FILE="kubectl-linux-v1.24.10+vmware.1.gz"
VCC_BUNDLE_FILE_PATH="kubectl-linux-v1.24.10+vmware.1"

download_kubectl_cli $VCC_PRODUCT $VCC_SUBPRODUCT $VCC_VERSION $VCC_FILE $VCC_BUNDLE_FILE_PATH



