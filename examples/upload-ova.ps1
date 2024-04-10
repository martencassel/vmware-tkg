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
    $VMHost = Get-VMHost -Name $VMHostName
    $Location = Get-ResourcePool -Name $Location
    $DataStore = Get-Datastore -Name $DataStoreName
    $Folder = Get-Folder -Name $FolderName
    $OVAConfiguration = Get-OvfConfiguration -Ovf $OVAFilename
    $OVAConfiguration.NetworkMapping.nic0.Value = $NetworkName
    Import-VApp -Name $Name -Source $OVAFilename -VMHost $VMHost -Datastore $Datastore -InventoryLocation $Folder -Location $Location -OvfConfiguration $OVAConfiguration
#    Set-VM -VM $OVAFilename -ToTemplate -Confirm:$false
}
$Cred = Get-Credential -UserName $Configuration.VCenterUser
Connect-VIServer -Server vcsa.lab.local -Credential $Cred -Force

$TKGVersion = "2.1.1"
$FolderName = "TKG"
#(Get-Datacenter)[0]|get-folder -Name vm | New-Folder $FolderName

# 2.1.1
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

# 2.2.0
$PhotonImages =@(
    "photon-3-kube-v1.25.7+vmware.2-tkg.1-8795debf8031d8e671660af83b673daa.ova"
    "photon-3-kube-v1.24.11+vmware.1-tkg.1-23267fd741797cde1d2be365ea5df6b4.ova"
    "photon-3-kube-v1.23.17+vmware.1-tkg.1-879196c3a566442fc5aeea6ac084766b.ova"
)
foreach($OVAFile in $PhotonImages) {
    get-tkg-file.sh $TKGVersion $OVAFile $OVAFile
}
foreach ($OVAFile in $PhotonImages) {
    UploadOVA -Name $OVAFile -OVAFilename $OVAFile -VMHostName $Configuration.VMHostName -DataStoreName $Configuration.DataStoreName -FolderName $FolderName -Location $Configuration.ResourcePoolName -NetworkName $Configuration.NetworkName
}

# 2.3.0
$PhotonImages =@(
    "photon-3-kube-v1.26.5+vmware.2-tkg.1-f8919b22f67e5eb2a4142054782c3eab.ova"
    "photon-3-kube-v1.25.10+vmware.2-tkg.1-2d1356855dfe81599986b89496fe9306.ova"
    "photon-3-kube-v1.24.14+vmware.2-tkg.1-7ed5f4e1123033e3385d17cbb375c112.ova"
)
foreach($OVAFile in $PhotonImages) {
    get-tkg-file.sh $TKGVersion $OVAFile $OVAFile
}
foreach ($OVAFile in $PhotonImages) {
    UploadOVA -Name $OVAFile -OVAFilename $OVAFile -VMHostName $Configuration.VMHostName -DataStoreName $Configuration.DataStoreName -FolderName $FolderName -Location $Configuration.ResourcePoolName -NetworkName $Configuration.NetworkName
}

# 2.3.1
$PhotonImages =@(
    "photon-3-kube-v1.26.8+vmware.1-tkg.1-ff40cdc22d4ef4b2a0665fe4e99aa8d5.ova"
    "photon-3-kube-v1.25.13+vmware.1-tkg.1-ce9831dba73845e754647ef141908264.ova"
    "photon-3-kube-v1.24.17+vmware.1-tkg.1-f31832043f9e1e56bec3e1fde59e830d.ova"
)
foreach($OVAFile in $PhotonImages) {
    get-tkg-file.sh $TKGVersion $OVAFile $OVAFile
}
foreach ($OVAFile in $PhotonImages) {
    UploadOVA -Name $OVAFile -OVAFilename $OVAFile -VMHostName $Configuration.VMHostName -DataStoreName $Configuration.DataStoreName -FolderName $FolderName -Location $Configuration.ResourcePoolName -NetworkName $Configuration.NetworkName
}

# 2.4.0
$PhotonImages = @(
    "photon-3-kube-v1.27.5+vmware.1-tkg.1-cac282289bb29b217b808a2b9b0c0c46.ova"
    "photon-3-kube-v1.26.8+vmware.1-tkg.1-5bfc988c8b83d44a96a079cdcda95c97.ova"
    "photon-3-kube-v1.25.13+vmware.1-tkg.1-90474fbeb493aec5c7f4911529f71225.ova"    
)
foreach($OVAFile in $PhotonImages) {
    get-tkg-file.sh $TKGVersion $OVAFile $OVAFile
}
foreach ($OVAFile in $PhotonImages) {
    UploadOVA -Name $OVAFile -OVAFilename $OVAFile -VMHostName $Configuration.VMHostName -DataStoreName $Configuration.DataStoreName -FolderName $FolderName -Location $Configuration.ResourcePoolName -NetworkName $Configuration.NetworkName
}

# 2.4.1
$PhotonImages = @(
    "photon-3-kube-v1.27.5+vmware.1-tkg.1-cac282289bb29b217b808a2b9b0c0c46.ova"
    "photon-3-kube-v1.26.8+vmware.1-tkg.1-5bfc988c8b83d44a96a079cdcda95c97.ova"
    "photon-3-kube-v1.25.13+vmware.1-tkg.1-90474fbeb493aec5c7f4911529f71225.ova"
)
foreach($OVAFile in $PhotonImages) {
    get-tkg-file.sh $TKGVersion $OVAFile $OVAFile
}
foreach ($OVAFile in $PhotonImages) {
    UploadOVA -Name $OVAFile -OVAFilename $OVAFile -VMHostName $Configuration.VMHostName -DataStoreName $Configuration.DataStoreName -FolderName $FolderName -Location $Configuration.ResourcePoolName -NetworkName $Configuration.NetworkName
}

# 2.5.0
$PhotonImages = @(
    "photon-5-kube-v1.28.4+vmware.1-tkg.1-10e0361a69712ac4a62217bc87575a1c.ova"
    "photon-5-kube-v1.27.8+vmware.1-tkg.1-photon5.ova"
    "photon-3-kube-v1.27.8+vmware.1-tkg.1-photon3-3.ova"
    "photon-3-kube-v1.26.11+vmware.1-tkg.1-ff0d78083ac007e86b5aa952064b14be.ova"
)
foreach($OVAFile in $PhotonImages) {
    get-tkg-file.sh $TKGVersion $OVAFile $OVAFile
}
foreach ($OVAFile in $PhotonImages) {
    UploadOVA -Name $OVAFile -OVAFilename $OVAFile -VMHostName $Configuration.VMHostName -DataStoreName $Configuration.DataStoreName -FolderName $FolderName -Location $Configuration.ResourcePoolName -NetworkName $Configuration.NetworkName
}


#Get-Template
#dir vi:/Datacenter/vm/$FolderName
