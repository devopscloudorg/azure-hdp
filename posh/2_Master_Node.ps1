<#############################################################################################################
Hadoop on Azure Virtual Machines

.SYNOPSIS 
  Create the Management node for Hadoop on Azure deployments on Azure virtual machines.  

.DESCRIPTION 
  Used to automate the creation of Windows Azure infrastructure to support the deploying Hadoop  
  on Windows Azure Virtual Machines.  

  The virtual machines will be named based on a prefix.  Each cloud service contains a single virtual machine.
  
  The script will accept a parameter specifying the number of disks to attach to each virtual machine.
  
  Note: This script requires an Azure Storage Account to run.  A storage account can be  
  specified by setting the subscription configuration.  For example: 
    Set-AzureSubscription -SubscriptionName "MySubscription" -CurrentStorageAccount "MyStorageAccount" 
  
.EXAMPLE 
  .\2_Master_Nodes.ps1 -imageName "OpenLogic" -adminUserName "clusteradmin" -adminPassword "Password.1" -instanceSize "ExtraLarge" -diskSizeInGB 0 -numofDisks 0 `
    -vmNamePrefix "hdpazure" -cloudServicePrefix "hdpazure" -affinityGroupLocation "East US" -affinityGroupName "hdpazureAG" `
    -affinityGroupDescription "Affinity Group used for HDP on Azure VM" -affinityGroupLabel "Hadoop on Azure VM AG HDP" -virtualNetworkName "Hadoop-NetworkHDP" `
    -virtualSubnetname "App" -storageAccountName "hdpstorage"

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
    [string]$storageAccountName
    ) 

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
## Create the virtual machine for the master image to clone the cluster nodes 
###########################################################################################################
$vmName = $vmNamePrefix + "M"
$cloudServiceName = $cloudServicePrefix + "M"
    
.\0_Create-VM.ps1 -imageName $imageName -adminUserName $adminUserName -adminPassword $adminPassword -instanceSize $instanceSize -diskSizeInGB $diskSizeInGB -vmName $vmName -cloudServiceName $cloudServiceName -affinityGroupName $affinityGroupName -virtualNetworkName $virtualNetworkName -virtualSubnetname $virtualSubnetname -numofDisks 0
