Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -ParticipateInCeip $false -Force -Confirm:$false 

$Configuration = New-Object -TypeName PSObject -Property @{
    Server = "vcsa.lab.local"
    VCenterUser = "Administrator@lab.local"
    ResourcePoolName = "Resources"
    NetworkName = "LabNetwork"
    VMHostName = "192.168.3.50"
    DataStoreName = "datastore1"
}

Function UploadOVA {
    param (
        [string]$Name,
        [string]$OVAFilename,
        [string]$VMHostName,
        [string]$DataStoreName,
        [string]$FolderName,
        [string]$Location,
        [string]$NetworkName
    )
    $VMHost           = Get-VMHost -Name $VMHostName
    $Location         = Get-ResourcePool -Name $Location
    $DataStore        = Get-Datastore -Name $DataStoreName
    $Folder           = Get-Folder -Name $FolderName
    $OVAConfiguration = Get-OvfConfiguration -Ovf $OVAFilename
    $OVAConfiguration.NetworkMapping.nic0.Value = $NetworkName
    Import-VApp -Name $Name -Source $OVAFilename -VMHost $VMHost -Datastore $Datastore -InventoryLocation $Folder -Location $Location -OvfConfiguration $OVAConfiguration
    Set-VM -VM $OVAFilename -ToTemplate -Confirm:$false
}
$Cred = Get-Credential -UserName $Configuration.VCenterUser
Connect-VIServer -Server vcsa.lab.local -Credential $Cred -Force

$TKGVersion = "2.1.1"
$FolderName = "tkg-$TKGVersion"
(Get-Datacenter)[0]|get-folder -Name vm | New-Folder $FolderName

$PhotonImages = @(
    "photon-3-kube-v1.24.10+vmware.1-tkg.1-fbb49de6d1bf1f05a1c3711dea8b9330.ova",
    "photon-3-kube-v1.23.16+vmware.1-tkg.1-0baa1bef6f5d4a3ca3abe31fd4cd1607.ova",
    "photon-3-kube-v1.22.17+vmware.1-tkg.1-a10ef8e088cc2c89418bca79a2fcc594.ova"
)
foreach($OVAFile in $PhotonImages) {
    get-tkg-file.sh $TKGVersion $OVAFile $OVAFile
}
foreach ($OVAFile in $PhotonImages) {
    UploadOVA -Name $OVAFile -OVAFilename $OVAFile -VMHostName $Configuration.VMHostName -DataStoreName $Configuration.DataStoreName -FolderName $FolderName -Location $Configuration.ResourcePoolName -NetworkName $Configuration.NetworkName
}

#Get-Template
#dir vi:/Datacenter/vm/TKG|fl
