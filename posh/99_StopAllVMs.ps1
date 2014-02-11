$imageNamePrefix = "ncdHDP"

#Remove the Cloud Services, VMs, and Disks
Get-AzureVM | where {$_.Name -like "*$imageNamePrefix*"} | Stop-AzureVM -Force

<#
$imageNamePrefix = "ncdHDP"

#Remove the Cloud Services, VMs, and Disks
Get-AzureVM | where {$_.Name -like "*$imageNamePrefix*"} | Restart-AzureVM 
#>