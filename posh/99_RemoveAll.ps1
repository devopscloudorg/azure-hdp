$affinityGroupName = "ncdAGHDP"
$virtualNetworkName = "Hadoop-NetworkHDP"
$imageNamePrefix = "ncdHDP"

#Remove the Cloud Services, VMs, and Disks
get-azureservice | where {$_.Label -like "*$imageNamePrefix*"} | Remove-AzureService -DeleteAll -Force

#Remove Virtual Network
#Blech.  The easiest way is through the portal right now.

#Remove the Affinity Group
Remove-AzureAffinityGroup -Name $affinityGroupName
