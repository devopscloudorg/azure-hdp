<#############################################################################################################
Hadoop on Azure Virtual Machines

.SYNOPSIS 
  Used to automate the creation of an image from a virtual machine.  

  Note: This script requires an Azure Storage Account to run.  A storage account can be  
  specified by setting the subscription configuration.  For example: 
    Set-AzureSubscription -SubscriptionName "MySubscription" -CurrentStorageAccount "MyStorageAccount" 
  
.EXAMPLE 
  .\0_Capture_Image.ps1 -vmNamePrefix "ncdHDP" -storageAccountName "" -imageContainerName ""

############################################################################################################>

param(
    # The name of the vm. 
    [Parameter(Mandatory = $true)]  
    [string]$vmNamePrefix, 
    
    # The name of the storage account. 
    [Parameter(Mandatory = $true)]  
    [string]$storageAccountName,

    # The name of the storage container for the image. 
    [Parameter(Mandatory = $true)]  
    [string]$imageContainerName
    ) 

###########################################################################################################
## Set constants for the vhd container name and the vm name
########################################################################################################### 
$vhdContainerName="vhds"
$vmName= $vmNamePrefix + "M"

###########################################################################################################
## Capture the name of the vhd file.
########################################################################################################### 
$vmVHD=Get-AzureVM $vmName –Name $vmName | Get-AzureDataDisk -Lun 0
$vmVHDName= ($vmVHD| %{ $_.DiskName}) + ".vhd"

###########################################################################################################
## Assign the name of the image and image vhd file.
########################################################################################################### 
$imageName= $vmName;
$imageVHDName= $vmName + ".vhd";

###########################################################################################################
#Stop the virtual machine.
########################################################################################################### 
Get-AzureVM | where {$_.Name -eq "*$vmName"} | Stop-AzureVM -Force

## Add a wait?

###########################################################################################################
## Assign the context of the storage account.
########################################################################################################### 
$storageKey = (Get-AzureStorageKey -StorageAccountName $storageAccountName).Primary;
$storageContext=New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageKey -Protocol Https;

###########################################################################################################
## Copy the vm file to the image container.
########################################################################################################### 
$imageBlob=Start-CopyAzureStorageBlob 
    -SrcContext $storageContext -SrcBlob $vmVHDName -SrcContainer $vhdContainerName 
    -DestContext $storageContext -DestContainer $imageContainerName -DestBlob $imageVHD;
# Wait for copy to complete
$imageBlob | Get-AzureStorageBlobCopyState -WaitForComplete;

###########################################################################################################
## Create an image from the new vhd file in the images container.
########################################################################################################### 
$imageURI = "https://$storageAccountName.blob.core.windows.net/$imageContainerName/$imageVHD";

Add-AzureVMImage -ImageName $imageName -OS "Linux" -MediaLocation  $imageURI -Label "Hadoop Master Image";

###########################################################################################################
# Remove the virtual machine and cloud service.
########################################################################################################### 
Get-AzureService | where {$_.Label -eq $vmName} | Remove-AzureService -DeleteAll -Force