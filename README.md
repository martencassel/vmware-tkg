# VMware TKG helper 

Some helper commands to manage Tanzu Kubernetes Grid Standalone Cluster Management.
These commands aim to help the following use cases

- Install the Tanzu CLI
- Prepare vSphere
- Deploy a standalone management cluster
- Upgrade a management cluster

Some specific features

- Find out what files are required to download in order to setup a specific TKG release version
- Automatically download and install the Tanzu CLI for a specific standalone TKG version (including kubectl) 
- List the avilable versions of TKG that is published on VMware Customer Connect
- Download a specific file for a TKG version, such as a OVA file

## Demo

[![asciicast](https://asciinema.org/a/jIGKSusKSOmTSIjinHzcn8tLI.svg)](https://asciinema.org/a/jIGKSusKSOmTSIjinHzcn8tLI)



## Installation

Clone this repo. These tools require VMWare Customer Connect CLI avilable from https://github.com/vmware-labs/vmware-customer-connect-cli/releases.

## Authentication

The Customer Connect username and password needs to be set in your environment using the following variables:

Example below for Linux:

```
export VCC_USER='email@email.com'
export VCC_PASS='##'
```


## Usage
The examples below assume that the credentials have been exported as environmental variables.


```
  # List all versions of TKG
  ./tkg/bin/get-tkg-versions.sh
  '2.5.0' '2.4.1' '2.4.0' '2.3.1' '2.3.0' '2.2.0' '2.1.1' '2.1.0' '1.6.1' '1.6.0' '1.5.4' '1.5.3' '1.5.2' '1.5.1' '1.5.0' '1.4.3' '1.4.2' '1.4.1' '1.4.0' '1.3.1' '1.3.0' '1.2.1' '1.2.0' '1.1.3' '1.1.2' '1.1' '1.0'

  # Download TKG cli binaries (tanzu cli and kubectl) to the current working directory.
  ./tkg/bin/get-tanzu-cli.sh 2.1.1
  ...
  ./tanzu version
  ./kubectl version --short

  # List files available from Customer Connect for a specific TKG version
  ./tkg/bin/get-tkg-files.sh 2.1.0

  # Download a specific file from a TKG release on Customer Connect
   ./tkg/bin/get-tkg-file.sh 2.1.0 kubectl-linux-v1.24.9+vmware.1.gz kubectl-linux-v1.24.9+vmware.

  # Download a specific OVA for a TKG release
  ./tkg/bin/get-tkg-file.sh 2.1.0 photon-3-kube-v1.24.9+vmware.1-tkg.1-f5e94dab9dfbb9988aeb94f1ffdc6e5e.ova photon-3-kube-v1.24.9+vmware.1-tkg.1-f5e94dab9dfbb9988aeb94f1ffdc6e5e.ova

```

## Known Issues

TODO


## Testing

TODO

## License
Apache License 
