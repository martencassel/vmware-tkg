# VMware TKG helper 

Some helper commands to manage Tanzu Kubernetes Grid Standalone Cluster Management.

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
  ./bin/get-tkg-versions.sh

  # Download a specific TKG CLI versions and kubectl to the local directory from VMWare Customer Connect
  ./bin/get-tanzu-cli.sh 2.1.1
  ...
  ./tanzu version
  ./kubectl version --short

  # List files available from Customer Connect for a specific TKG version
  ./bin/get-tkg-files.sh 2.1.0

  # Download a specific file from a TKG release on Customer Connect
   ./bin/get-tkg-file.sh 2.1.0 kubectl-linux-v1.24.9+vmware.1.gz kubectl-linux-v1.24.9+vmware.1

```

## Known Issues

TODO


## Testing

TODO

## License
Apache License 