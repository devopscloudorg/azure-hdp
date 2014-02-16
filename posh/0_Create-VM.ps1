<#############################################################################################################
Hadoop on Azure Virtual Machines

.SYNOPSIS 
  Creates a Linux Virtual Machine for use with Hadoop deployments on Azure. 
.DESCRIPTION 
  Used to automate the creation of Windows Azure VMs to support the deploying Hadoop  
  on Windows Azure Virtual Machines.  This script will be run from master scripts.

  The virtual machines will be named based on a prefix.  Each cloud service contains a single virtual machine.
  
  Note: This script requires an Azure Storage Account to run.  A storage account can be  
  specified by setting the subscription configuration.  For example: 
    Set-AzureSubscription -SubscriptionName "MySubscription" -CurrentStorageAccount "MyStorageAccount" 
  
.EXAMPLE 
  .\0_Create-VM.ps1 -imageName "b39f27a8b8c64d52b05eac6a62ebad85__Ubuntu_DAILY_BUILD-saucy-13_10-amd64-server-20140119-en-us-30GB" `
    -adminUserName "clusteradmin" -adminPassword "Password.1" -instanceSize "ExtraLarge" -diskSizeInGB 100 `
    -vmName "hdpazure" -cloudServiceName "hdpazure" -affinityGroupName "hdpazureAG" -virtualSubnetname "App" -virtualNetworkName "Hadoop-NetworkHDP" -numofDisks 2 

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
    [int]$DiskSizeInGB, 
 
    # The name of the vm. 
    [Parameter(Mandatory = $true)]  
    [string]$vmName, 
 
    # The name of the affinity group. 
    [Parameter(Mandatory = $true)]  
    [string]$affinityGroupName, 
 
    # The name of the virtual network. 
    [Parameter(Mandatory = $true)]  
    [string]$virtualNetworkName, 

    # The name of the virtual subnet. 
    [Parameter(Mandatory = $true)]  
    [string]$virtualSubnetname, 
    
    # The name of the cloud service. 
    [Parameter(Mandatory = $true)]  
    [string]$cloudServiceName,

    # Number of data disks to add to each virtual machine 
    [Parameter(Mandatory = $true)] 
    [Int32]$numOfDisks
    ) 
 

# The script has been tested on Powershell 3.0 
Set-StrictMode -Version 3 
 
 
# Following modifies the Write-Verbose behavior to turn the messages on globally for this session 
$VerbosePreference = "Continue" 
 
 
# Check if Windows Azure Powershell is avaiable 
if ((Get-Module -ListAvailable Azure) -eq $null) 
{ 
    throw "Windows Azure Powershell not found! Please install from http://www.windowsazure.com/en-us/downloads/#cmd-line-tools" 
} 


$vmConfig = New-AzureVMConfig -Name $vmName -InstanceSize $instanceSize -ImageName $imageName

$vmDetails = Add-AzureProvisioningConfig -Linux -LinuxUser $adminUserName -Password $adminPassword -VM $vmConfig                                             
    for ($index = 0; $index -lt $numOfDisks; $index++) 
    {  
        $diskLabel = $cloudServiceName + $index 
        $vmConfig = $vmConfig |  
                        Add-AzureDataDisk -CreateNew -DiskSizeInGB $diskSizeInGB -DiskLabel $diskLabel -LUN $index         
    } 

            Remove-AzureEndpoint "SSH" -VM $vmConfig
            Add-AzureEndpoint -Protocol tcp -PublicPort 22 -LocalPort 22 -Name "SSH" -VM $vmConfig                               
            Set-AzureSubnet $virtualSubnetname -VM $vmConfig

$result = New-AzureVM -ServiceName $cloudServiceName -VMs @($vmDetails) -AffinityGroup $affinityGroupName -VNetName $virtualNetworkName -ErrorVariable errs
if($? -eq $true)
{
                                      
    Write-Host "Service " + $cloudServiceName + " was created successfully. result is " + $result.OperationDescription                                              
}
else
{                    
    Write-Host "Service " + $cloudServiceName + ",Error is: " + $errs[0]
} 