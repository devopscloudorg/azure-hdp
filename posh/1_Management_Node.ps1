<############################################################################################################
Hadoop on Azure Virtual Machines

.SYNOPSIS 
  Create the Management node for Hadoop on Azure deployments on Azure virtual machines.  

.DESCRIPTION 
  Used to automate the creation of Windows Azure infrastructure to support the deploying Hadoop  
  on Windows Azure Virtual Machines.  

  The virtual machines will be named based on a prefix.  Each cloud service contains a single virtual machine.
  
  The script will accept a parameter specifying the number of disks to attach to each virtual machine.

  The Virtual Machine will be assigned a static IP.
  
  Note: This script requires an Azure Storage Account to run.  A storage account can be  
  specified by setting the subscription configuration.  For example: 
    Set-AzureSubscription -SubscriptionName "MySubscription" -CurrentStorageAccount "MyStorageAccount" 
  
.EXAMPLE 
  .\1_Management_Nodes.ps1 -imageName "OpenLogic" -adminUserName "clusteradmin" -adminPassword "Password.1" -instanceSize "ExtraLarge" -diskSizeInGB 100 -numofDisks 2 `
    -vmNamePrefix "hadoopazure" -cloudServicePrefix "hadoopazure" -affinityGroupLocation "East US" -affinityGroupName "hadoopazureAG" `
    -affinityGroupDescription "Affinity Group used for hadoop on Azure VM" -affinityGroupLabel "Hadoop on Azure VM AG" -virtualNetworkName "Hadoop-Network" `
    -virtualSubnetname "App" -storageAccountName "hadoopstorage" -installerPort 7180 -hostsfile ".\hosts.txt" -hostscript ".\hostscript.sh" 

############################################################################################################>

param( 
    # The name of the image.  Can be wildcard pattern. 
    [Parameter(Mandatory = $true)]  
    [string]$imageName, 
  
    # The administrator username. 
    [Parameter(Mandatory = $true)]  
    [string]$adminUserName, 
  
    # The administrator password. 
    [Parameter(Mandatory = $true)]  
    [string]$adminPassword, 

    # The size of the instances. 
    [Parameter(Mandatory = $true)]  
    [string]$instanceSize, 
     
    # The size of the disk(s). 
    [Parameter(Mandatory = $true)]  
    [int]$diskSizeInGB,
     
    # Number of data disks to add to each virtual machine 
    [Parameter(Mandatory = $true)] 
    [Int32]$numOfDisks,
 
    # The name of the vm. 
    [Parameter(Mandatory = $true)]  
    [string]$vmNamePrefix, 
    
    # The name of the cloud service. 
    [Parameter(Mandatory = $true)]  
    [string]$cloudServicePrefix,

    # The name of the affinity group. 
    [Parameter(Mandatory = $true)]  
    [string]$affinityGroupLocation, 
 
    # The name of the affinity group. 
    [Parameter(Mandatory = $true)]  
    [string]$affinityGroupName, 

    # The description of the affinity group. 
    [Parameter(Mandatory = $true)]  
    [string]$affinityGroupDescription, 

    # The affinity group label. 
    [Parameter(Mandatory = $true)]  
    [string]$affinityGroupLabel, 

    # The name of the virtual network. 
    [Parameter(Mandatory = $true)]  
    [string]$virtualNetworkName,

    # The name of the virtual subnet. 
    [Parameter(Mandatory = $true)]  
    [string]$virtualSubnetname,

    # The name of the storage account. 
    [Parameter(Mandatory = $true)]  
    [string]$storageAccountName,

    # The port for the installer endpoint. 
    [Parameter(Mandatory = $true)]  
    [int]$installerPort,

    # The location of the hosts file. 
    [Parameter(Mandatory = $false)]  
    [string]$hostsfile = ".\hosts.txt",

    # The location of the hostscript. 
    [Parameter(Mandatory = $false)]  
    [string]$hostscript = ".\hostscript.sh"
    ) 

###########################################################################################################
## Remove previous versions of the files
###########################################################################################################
If (Test-Path $hostsfile) {
    Remove-Item $hostsfile
}

If (Test-Path $hostscript) {
    Remove-Item $hostscript
}

###########################################################################################################
## Create the Affinity Group, the Virtual Network and the Storage Account
###########################################################################################################
.\0_Create_AG_Storage_VNet.ps1 -affinityGroupLocation $affinityGroupLocation -affinityGroupName $affinityGroupName -affinityGroupDescription $affinityGroupDescription -affinityGroupLabel $affinityGroupLabel -virtualNetworkName $virtualNetworkName -virtualSubnetname $virtualSubnetname -storageAccountName $storageAccountName

###########################################################################################################
## Select the image to provision
###########################################################################################################
$image = Get-AzureVMImage | 
            ? label -Like "*$imageName*" | Sort-Object PublishedDate -Descending |
            select -First 1
$imageName = $image.ImageName

###########################################################################################################
## Create the management node virtual machine
### Write the hostscript and hosts file
### Set static IP on the VM
###########################################################################################################
$vmName = $vmNamePrefix + "0"
$cloudServiceName = $cloudServicePrefix + "0"
    
.\0_Create_VM.ps1 -imageName $imageName -adminUserName $adminUserName -adminPassword $adminPassword -instanceSize $instanceSize -diskSizeInGB $diskSizeInGB -vmName $vmName -cloudServiceName $cloudServiceName -affinityGroupName $affinityGroupName -virtualNetworkName $virtualNetworkName -virtualSubnetname $virtualSubnetname -numofDisks $numOfDisks 

#capture vm variable
    $vm = Get-AzureVM -ServiceName $cloudServiceName -Name $vmName
    $IpAddress = $vm.IpAddress

#Add endpoint for the distribution installation software
    Add-AzureEndpoint -Protocol tcp -PublicPort $installerPort -LocalPort $installerPort -Name "Installer" -VM $vm | Update-AzureVM

# Write to the hostscript.sh file
	"scp /etc/hosts root@${vmName}:/etc" | Out-File $hostscript -encoding ASCII -append 

# Write to the hosts.txt file
    "$IpAddress`t$vmName" | Out-File $hostsfile -encoding ASCII -append 

# Set Static IP on the VM
    Set-AzureStaticVNetIP -IPAddress $IpAddress -VM $vm | Update-AzureVM