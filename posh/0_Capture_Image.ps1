<#############################################################################################################
Hadoop on Azure Virtual Machines

.SYNOPSIS 
  Used to automate the creation of an image from a virtual machine.  

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
    [Parameter(Mandatory = $false)]  
    [string]$imageContainerName = "images"
    ) 

###########################################################################################################
## Set constants for the vhd container name and the vm name
########################################################################################################### 
$vhdContainerName="vhds"
$vmName= $vmNamePrefix + "m"

###########################################################################################################
## Assign the context of the storage account.
########################################################################################################### 
$storageKey = (Get-AzureStorageKey -StorageAccountName $storageAccountName).Primary
$storageContext=New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageKey -Protocol Https

###########################################################################################################
## Capture the name of the vhd file.
########################################################################################################### 
$vmVHD = Get-AzureDisk | Where-Object {$_.AttachedTo.RoleName –eq $vmName} 
$vmVHDURI= ($vmVHD.MediaLink)

###########################################################################################################
## Assign the name of the image and image vhd file.
########################################################################################################### 
$imageName= $vmName
$imageVHDName= $vmName + ".vhd"

###########################################################################################################
#Stop the virtual machine.
########################################################################################################### 
Get-AzureVM | where {$_.Name -eq $vmName} | Stop-AzureVM -Force

###########################################################################################################
## Copy the vm file to the image container.
###########################################################################################################
$imageBlob=Start-CopyAzureStorageBlob -Context $storageContext -AbsoluteUri $vmVHDURI.AbsoluteUri -DestContext $storageContext -DestContainer $imageContainerName -DestBlob $imageVHDName -Force
# Wait for copy to complete
$imageBlob | Get-AzureStorageBlobCopyState -WaitForComplete

###########################################################################################################
## Create an image from the new vhd file in the images container.
########################################################################################################### 
$imageURI = "https://$storageAccountName.blob.core.windows.net/$imageContainerName/$imageVHDName"

Add-AzureVMImage -ImageName $imageName -OS "Linux" -MediaLocation  $imageURI -Label "Hadoop Master Image"

###########################################################################################################
# Remove the virtual machine and cloud service.
########################################################################################################### 
Get-AzureService | where {$_.Label -eq $vmName} | Remove-AzureService -DeleteAll -Force