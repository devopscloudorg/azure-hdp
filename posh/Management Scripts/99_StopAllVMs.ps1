<#############################################################################################################
Hadoop on Azure Virtual Machines

.SYNOPSIS 
  Management script to stop all virtual machines follow a naming convention.   

############################################################################################################>

$vmNamePrefix = ""

start-job -scriptblock{Get-AzureVM | where {$_.ServiceName -like "*$vmNamePrefix*"} | restart-AzureVM} 


