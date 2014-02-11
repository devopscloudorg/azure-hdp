<#############################################################################################################
Hadoop on Azure Virtual Machines

.SYNOPSIS 
  Create the storage accounts for Hadoop on Azure deployments on Azure virtual machines.  

.DESCRIPTION 
  Used to automate the creation of Windows Azure infrastructure to support the deploying Hadoop  
  on Windows Azure Virtual Machines.  

  Create a single storage account with two containers.  One container will store VHDs and the second will store scripts. The scripts container 
  will be public to ease the movement of scripts into Linux VMs.
  
.EXAMPLE 
  .\0_Create_Storage_Account.ps1 -affinityGroupName "ncdAGHDP" -clusterStorageAccount "hdpstorage" -vhdStorageContainer "vhds" -scriptStorageContainer "scripts"


############################################################################################################>

param ( 
    # Affinity Group of the blob storage account
    [Parameter(Mandatory = $true)] 
    [String]$affinityGroupName, 
     
    # Blob storage account for storing vhds and scripts 
    [Parameter(Mandatory = $false)] 
    [String]$clusterStorageAccount = "", 
     
    # Blob storage container to store the scripts 
    [Parameter(Mandatory = $false)] 
    [String]$scriptStorageContainer = ""
    )      

# Check if account already exists then use it 
$storageAccount = Get-AzureStorageAccount -StorageAccountName $clusterStorageAccount -ErrorAction SilentlyContinue 
if ($storageAccount -eq $null) { 
    Write-Verbose "Creating new storage account $clusterStorageAccount." 
    $storageAccount = New-AzureStorageAccount –StorageAccountName $clusterStorageAccount -AffinityGroup $affinityGroupName 
} else { 
    Write-Verbose "Using existing storage account $clusterStorageAccount." 
} 

$storageContext = New-AzureStorageContext –StorageAccountName $clusterStorageAccount -StorageAccountKey (Get-AzureStorageKey $clusterStorageAccount).Primary 

$storageContainer = $scriptStorageContainer 
$storageContainer = Get-AzureStorageContainer -Name $scriptStorageContainer -Context $storageContext -ErrorAction SilentlyContinue 
if ($storageContainer -eq $null) { 
    Write-Verbose "Creating new storage container $scriptStorageContainer." 
    $storageContainer = New-AzureStorageContainer -Name $scriptStorageContainer -Context $storageContext -Permission Blob
} else { 
    Write-Verbose "Using existing storage container $clusterStorageContainer." 
} 
