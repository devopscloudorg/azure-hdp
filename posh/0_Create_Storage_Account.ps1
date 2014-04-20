<#############################################################################################################
Hadoop on Azure Virtual Machines

.SYNOPSIS 
  Create the storage accounts for Hadoop on Azure deployments on Azure virtual machines.  

.DESCRIPTION 
  Used to automate the creation of Windows Azure infrastructure to support the deploying Hadoop  
  on Windows Azure Virtual Machines.  

  Create a single storage accountr.  
  
.EXAMPLE 
  .\0_Create_Storage_Account.ps1 -affinityGroupName "hadoopazureAG" -storageAccountName "hadoopstorage" 


############################################################################################################>

param ( 
    # Affinity Group of the blob storage account
    [Parameter(Mandatory = $true)] 
    [String]$affinityGroupName, 
     
    # Blob storage account for storing vhds and scripts 
    [Parameter(Mandatory = $true)] 
    [String]$storageAccountName 
    )      

# Check if account already exists then use it 

$storageAccount = Get-AzureStorageAccount | Where {$_.StorageAccountName -eq $storageAccountName}
if ($storageAccount -eq $null) { 
    Write-Verbose "Creating new storage account $storageAccountName." 
    $storageAccount = New-AzureStorageAccount –StorageAccountName $storageAccountName -AffinityGroup $affinityGroupName 
    Set-AzureStorageAccount -StorageAccountName $storageAccountName –GeoReplicationEnabled $false 
} else { 
    Write-Verbose "Using existing storage account $storageAccountName." 
} 
