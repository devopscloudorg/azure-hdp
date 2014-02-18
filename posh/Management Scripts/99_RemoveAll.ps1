<#############################################################################################################
Hadoop on Azure Virtual Machines

.SYNOPSIS 
  Management script to remove all virtual machines that are part of a service and remove the affinity group. Manually remove the virtual network configurations.  

############################################################################################################>
$affinityGroupName = "ncdAGHDP"
$virtualNetworkName = "Hadoop-NetworkHDP"
$vmNamePrefix = "hdpazure"

#Remove the Cloud Services, VMs, and Disks
get-azureservice | where {$_.Label -like "*$vmNamePrefix*"} | Remove-AzureService -DeleteAll -Force

#Remove Virtual Network
#Blech.  The easiest way is through the portal right now.

#Remove the Affinity Group
Remove-AzureAffinityGroup -Name $affinityGroupName
