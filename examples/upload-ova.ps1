docker run -v $(pwd):/host -it vmware/powerclicore

Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -ParticipateInCeip $false

cd /host

$Configuration = New-Object -TypeName PSObject -Property @{
    Server = "vcsa.lab.local"
    VcenterUser = "Administrator@lab.local"
    ResourcePool = "Resources"
    Network = "LabNetwork"
    OvaFilename = "photon-3-kube-v1.24.10+vmware.1-tkg.1-fbb49de6d1bf1f05a1c3711dea8b9330.ova"
    OvaFilePath = "./photon-3-kube-v1.24.10+vmware.1-tkg.1-fbb49de6d1bf1f05a1c3711dea8b9330.ova"
    Vmhost = "192.168.3.50"
    Datastore = "datastore1"
    FolderName = "TKG"
}

$cred = Get-Credential -UserName $Configuration.VcenterUser -Message "Enter your password"
Connect-VIServer -Server vcsa.lab.local -Credential $cred -Force

$vmhost = Get-VMHost -Name $Configuration.Vmhost
$location = Get-ResourcePool -Name $Configuration.ResourcePool
$ds = Get-Datastore -Name $Configuration.Datastore
$folder = Get-Folder -Name  $Configuration.FolderName
$ovaConfig = Get-OvfConfiguration -Ovf $Configuration.OvaFilePath
$ovaConfig.NetworkMapping.nic0.Value = $Configuration.Network

Import-VApp -Name $ova_filename -Source $ova -VMHost $vmhost -Datastore $ds -InventoryLocation $folder -Location $location -OvfConfiguration $ovaConfig
Set-VM -VM $ova_filename -ToTemplate

Get-Template

dir vi:/Datacenter/vm/TKG|fl
