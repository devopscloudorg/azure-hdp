<#############################################################################################################
Hadoop on Azure Virtual Machines

.SYNOPSIS 
  Used to automate the creation of Windows Azure nodes for the Hadoop on Windows Azure cluster.  

  The virtual machines will be named based on a prefix.  Each cloud service contains a single virtual machine.

  The script will accept a parameter specifying the number of disks to attach to each virtual machine.
  
  Note: This script requires an Azure Storage Account to run.  A storage account can be  
  specified by setting the subscription configuration.  For example: 
    Set-AzureSubscription -SubscriptionName "MySubscription" -CurrentStorageAccount "MyStorageAccount" 
  
.EXAMPLE 
  .\3_Cluster_Nodes.ps1 -imageName "azurehdpm" -adminUserName "clusteradmin" -adminPassword "Password.1" -instanceSize "ExtraLarge" -diskSizeInGB 100 -numofDisks 2 `
    -vmNamePrefix "azurehdp" -cloudServicePrefix "azurehdp" -numNodes 1 -affinityGroupName "azurehdpAG" -virtualNetworkName "Hadoop-NetworkHDP" -virtualSubnetname "App" `
    -storageAccountName "hdpstorage" -hostsfile ".\hosts.txt" -mntscript ".\mountdrive.sh" 

############################################################################################################>

param(
    # The name of the image.  Can be wildcard pattern. 

    [Parameter(Mandatory = $true)]  
    [string]$imageName, 
  
    # The administrator username. 
    [Parameter(Mandatory = $true)]  
    [string]$adminUserName, 
  
    # The administrator password. 
    [Parameter(Mandatory = $true)]  
    [string]$adminPassword, 

    # The size of the instances. 
    [Parameter(Mandatory = $true)]  
    [string]$instanceSize, 
     
    # The size of the disk(s). 
    [Parameter(Mandatory = $true)]  
    [int]$diskSizeInGB, 

    # Number of data disks to add to each virtual machine 
    [Parameter(Mandatory = $true)] 
    [Int32]$numOfDisks,
 
    # The name of the vm. 
    [Parameter(Mandatory = $true)]  
    [string]$vmNamePrefix, 
    
    # The name of the cloud service. 
    [Parameter(Mandatory = $true)]  
    [string]$cloudServicePrefix,

    # The name of the cloud service. 
    [Parameter(Mandatory = $true)]  
    [string]$numNodes,

    # The name of the affinity group. 
    [Parameter(Mandatory = $true)]  
    [string]$affinityGroupName, 

    # The name of the virtual network. 
    [Parameter(Mandatory = $true)]  
    [string]$virtualNetworkName,

    # The name of the virtual subnet. 
    [Parameter(Mandatory = $true)]  
    [string]$virtualSubnetname,
    
    # The name of the storage account. 
    [Parameter(Mandatory = $true)]  
    [string]$storageAccountName,

    # The location of the hosts file. 
    [Parameter(Mandatory = $false)]  
    [string]$hostsfile = ".\hosts.txt",

    # The location of the mntscript. 
    [Parameter(Mandatory = $false)]  
    [string]$mntscript = ".\mountdrive.sh"
    ) 


###########################################################################################################
## Set the storage account as the current storage account.
########################################################################################################### 
$subscriptionInfo = Get-AzureSubscription -Current
$subName = $subscriptionInfo | %{ $_.SubscriptionName }

Set-AzureSubscription -SubscriptionName $subName –CurrentStorageAccount $storageAccountName

###########################################################################################################
## Select the image to provision
###########################################################################################################
$image = Get-AzureVMImage -ImageName $imageName

###########################################################################################################
## Create the virtual machines for the cluster nodes 
#### Create a single cloud service for each VM
### Write the mountscript and hosts file
###########################################################################################################
For ($count = 1; $count -le $numNodes; $count++)
{
    $vmName = $vmNamePrefix + $count
    $cloudServiceName = $cloudServicePrefix + $count
    
    .\0_Create-VM.ps1 -imageName $imageName -adminUserName $adminUserName -adminPassword $adminPassword -instanceSize $instanceSize -diskSizeInGB $diskSizeInGB -vmName $vmName -cloudServiceName $cloudServiceName -affinityGroupName $affinityGroupName -virtualNetworkName $virtualNetworkName -virtualSubnetname $virtualSubnetname -numofDisks $numOfDisks 
    
#write to the mountdrive.sh file
    "ssh root@$vmName /root/scripts/makefilesystem.sh" | Out-File $mntscript -encoding ASCII -append 
	"scp /etc/hosts root@${vmName}:/etc" | Out-File $mntscript -encoding ASCII -append 

#write to the hosts.txt file
    $IpAddress = (Get-AzureVM $vmName).IpAddress
    #echo "$vmName`t$IpAddress" >> $hostsfile 
    "$IpAddress`t$vmName" | Out-File $hostsfile -encoding ASCII -append 
}

