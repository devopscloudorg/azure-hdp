<#############################################################################################################
Hadoop on Azure Virtual Machines

.SYNOPSIS 
  Management script to remove all virtual machines that are part of a service and remove the affinity group. Manually remove the virtual network configurations.  
  You will select each command to execute individually.
############################################################################################################>


<#############################################################################################################
#Set the variables.
#These should match the variables used to create the cluster.
############################################################################################################>
$affinityGroupName = ""
$virtualNetworkName = ""
$vmNamePrefix = ""
$storageAccountName = ""

<#############################################################################################################
#Remove the Cloud Services, VMs, and Disks
############################################################################################################>
get-azureservice | where {$_.Label -like "*$vmNamePrefix*"} | Remove-AzureService -DeleteAll -Force
Get-AzureVMImage| where {$_.ImageName -like "*$vmNamePrefix*"} | Remove-AzureVMImage

<#############################################################################################################
#Remove the storage account
############################################################################################################>
Get-AzureStorageAccount -StorageAccountName $storageAccountName |Remove-AzureStorageAccount

<#############################################################################################################
#Remove Virtual Network
Blech.  The easiest way is through the portal right now.
Open the Windows Azure Management Portal and navigate to Networks.
Select your network and click on Delete.  
Note: If you are using this network for other Azure applications, you may choose to skip this step. 
############################################################################################################>

<#############################################################################################################
#Remove the Affinity Group
############################################################################################################>
Remove-AzureAffinityGroup -Name $affinityGroupName
