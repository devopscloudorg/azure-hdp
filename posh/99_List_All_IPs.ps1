<#############################################################################################################
Hadoop on Azure Virtual Machines

.SYNOPSIS 
  Management script to list the IP addresses and DNS names of all machines that are part of a service.

############################################################################################################>

$vmNamePrefix = "azurehdp"

Get-AzureVM | Where {$_.ServiceName -like "*$vmNamePrefix*"} | SELECT ServiceName, Name | foreach-object { Get-AzureVM -ServiceName $_.ServiceName -Name $_.Name | Select ServiceName, Name, IPAddress, DNSName }