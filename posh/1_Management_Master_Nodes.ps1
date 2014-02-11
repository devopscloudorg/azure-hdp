<#############################################################################################################
Hadoop on Azure Virtual Machines

.SYNOPSIS 
  Create the Management and Master nodes for Hadoop on Azure deployments on Azure virtual machines.  

.DESCRIPTION 
  Used to automate the creation of Windows Azure infrastructure to support the deploying Hadoop  
  on Windows Azure Virtual Machines.  

  The virtual machines will be named based on a prefix.  Each cloud service contains a single virtual machine.
  
  The script will accept a parameter specifying the number of disks to attach to each virtual machine.
  
  Note: This script requires an Azure Storage Account to run.  A storage account can be  
  specified by setting the subscription configuration.  For example: 
    Set-AzureSubscription -SubscriptionName "MySubscription" -CurrentStorageAccount "MyStorageAccount" 
  
.EXAMPLE 
  .\1_Management_Master_Nodes.ps1 -imageName "OpenLogic" -adminUserName "clusteradmin" -adminPassword "Password.1" -instanceSize "ExtraLarge" -diskSizeInGB 100 -numofDisks 2 `
    -vmNamePrefix "ncdHDP" -cloudServicePrefix "ncdHDP" -affinityGroupLocation "East US" -affinityGroupName "ncdAGHDP" `
    -affinityGroupDescription "Affinity Group used for HDP on Azure VM" -affinityGroupLabel "Hadoop on Azure VM AG HDP" -virtualNetworkName "Hadoop-NetworkHDP" -virtualSubnetname "App" 

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

    # The name of the affinity group. 
    [Parameter(Mandatory = $true)]  
    [string]$affinityGroupLocation, 
 
    # The name of the affinity group. 
    [Parameter(Mandatory = $true)]  
    [string]$affinityGroupName, 

    # The description of the affinity group. 
    [Parameter(Mandatory = $true)]  
    [string]$affinityGroupDescription, 

    # The affinity group label. 
    [Parameter(Mandatory = $true)]  
    [string]$affinityGroupLabel, 

    # The name of the virtual network. 
    [Parameter(Mandatory = $true)]  
    [string]$virtualNetworkName,

    # The name of the virtual subnet. 
    [Parameter(Mandatory = $true)]  
    [string]$virtualSubnetname
    ) 

###########################################################################################################
## Create the Affinity Group
###########################################################################################################
if ((Get-AzureAffinityGroup | where {$_.Name -eq $affinityGroupName}) -eq $NULL) 
{
    New-AzureAffinityGroup -Location $affinityGroupLocation -Name $affinityGroupName -Description $affinityGroupDescription -Label $affinityGroupLabel
}
else
{
    Write-Host "Affinity Group" $affinityGroupName "Exists"
}

###########################################################################################################
## Create the Virtual Network
###########################################################################################################
# Get a temporary path for the network config...
$networkTempPath = [IO.Path]::GetTempFileName()

# Get the current network configuration...
Get-AzureVNetConfig -ExportToFile $networkTempPath

# Determine whether we got the network configuration...
if ((Test-Path $networkTempPath) -eq $false)
{
    # Didn't get a config file...
    # Load the full network config...
    [string]$networkConfig = Get-Content ("C:\Temp\NetworkDef-Full.xml")
    # Replace the placeholder name and affinity group with the variable values...
    $networkConfig = $networkConfig.Replace("placeholder-network", $virtualNetworkName).Replace("placeholder-affinitygroup", $affinityGroupName)
    # Save the network configuration...
    $networkConfig.Save($networkTempPath)
}
else
{
    # Got a config file...
    # Load the config file...
    [xml]$networkConfig = Get-Content $networkTempPath

    # Check for VirtualNetworkSites node...
    if ($networkConfig.Item("NetworkConfiguration").Item("VirtualNetworkConfiguration").Item("VirtualNetworkSites") -eq $NULL)
    {
        # VirtualNetworkSites node not found...create one...
        $virtualNetworkNamespace = "http://schemas.microsoft.com/ServiceHosting/2011/07/NetworkConfiguration"
        $vncNode = $networkConfig.CreateNode("element", "VirtualNetworkSites", $virtualNetworkNamespace)
        $networkConfig.Item("NetworkConfiguration").Item("VirtualNetworkConfiguration").AppendChild($vncNode)
    }

    # Merge in the predefined configuration...
    # Load the network config fragment...
    [string]$networkConfigNode = Get-Content ("C:\Temp\NetworkDef.xml")
    # Replace the placeholder name and affinity group with the variable values...
    $networkConfigNode = $networkConfigNode.Replace("placeholder-network", $virtualNetworkName).Replace("placeholder-affinitygroup", $affinityGroupName)
    # Merge the fragment into the full file...
    $networkConfig.Item("NetworkConfiguration").Item("VirtualNetworkConfiguration").Item("VirtualNetworkSites").InnerXML += $networkConfigNode
    # Save the network configuration...
    $networkConfig.Save($networkTempPath)
}

# Upload the network configuration...
Set-AzureVNetConfig -ConfigurationPath $networkTempPath

# Clean up the temporary file...
Remove-Item -Path $networkTempPath

###########################################################################################################
## Select the image to provision
###########################################################################################################
$image = Get-AzureVMImage | 
            ? label -Like "*$imageName*" | Sort-Object PublishedDate -Descending |
            select -First 1
$imageName = $image.ImageName

###########################################################################################################
## Create the management node virtual machine
###########################################################################################################
$vmName = $vmNamePrefix + "0"
$cloudServiceName = $cloudServicePrefix + "0"
    
.\0_Create-VM.ps1 -imageName $imageName -adminUserName $adminUserName -adminPassword $adminPassword -instanceSize $instanceSize -diskSizeInGB $diskSizeInGB -vmName $vmName -cloudServiceName $cloudServiceName -affinityGroupName $affinityGroupName -virtualNetworkName $virtualNetworkName -virtualSubnetname $virtualSubnetname -numofDisks $numOfDisks -isManagementNode "True"

###########################################################################################################
## Create the virtual machine for the master image to clone the cluster nodes 
###########################################################################################################

$vmName = $vmNamePrefix + "M"
$cloudServiceName = $cloudServicePrefix + "M"
    
.\0_Create-VM.ps1 -imageName $imageName -adminUserName $adminUserName -adminPassword $adminPassword -instanceSize $instanceSize -diskSizeInGB $diskSizeInGB -vmName $vmName -cloudServiceName $cloudServiceName -affinityGroupName $affinityGroupName -virtualNetworkName $virtualNetworkName -virtualSubnetname $virtualSubnetname -numofDisks $numOfDisks -isManagementNode "False"
