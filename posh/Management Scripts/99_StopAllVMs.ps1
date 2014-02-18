<#############################################################################################################
Hadoop on Azure Virtual Machines

.SYNOPSIS 
  Management script to stop all virtual machines follow a naming convention.   

############################################################################################################>
$vmNamePrefix = "ncdHDPa0"


Get-AzureVM | where {$_.Name -like "*$vmNamePrefix"} | Stop-AzureVM -Force

