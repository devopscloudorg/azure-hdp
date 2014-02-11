$imageNamePrefix = "ncdHDP"

Get-AzureVM | Where {$_.ServiceName -like "*$imageNamePrefix*"} | SELECT ServiceName, Name | foreach-object { Get-AzureVM -ServiceName $_.ServiceName -Name $_.Name | Select ServiceName, Name, IPAddress, DNSName }