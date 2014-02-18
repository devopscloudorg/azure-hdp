<#############################################################################################################
Hadoop on Azure Virtual Machines

.SYNOPSIS 
  Create the Affinity Group, Virtual Network and Storage Account for Hadoop on Azure deployments on Azure virtual machines.  

.DESCRIPTION 
  Used to automate the creation of Windows Azure infrastructure to support the deploying Hadoop  
  on Windows Azure Virtual Machines.  

.EXAMPLE 
  .\0_Create_AG_Storage_VNet -affinityGroupLocation "East US" -affinityGroupName "hdpazureAG" `
    -affinityGroupDescription "Affinity Group used for HDP on Azure VM" -affinityGroupLabel "Hadoop on Azure VM AG HDP" -virtualNetworkName "Hadoop-NetworkHDP" `
    -virtualSubnetname "App" -storageAccountName "hdpstorage"

############################################################################################################>

param( 
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
    [string]$virtualSubnetname,

    # The name of the storage account. 
    [Parameter(Mandatory = $true)]  
    [string]$storageAccountName
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
## Create the Storage Account and Scripts Container
## Set the new storage account as the current storage account. A new VHD container will be auto-generated
## when the virtual machines are created.
########################################################################################################### 
if ((Get-AzureStorageAccount | where {$_.StorageAccountName -eq $storageAccountName}) -eq $NULL) 
{.\0_Create_Storage_Account.ps1 -affinityGroupName $affinityGroupName  -storageAccountName $storageAccountName 
}

$subscriptionInfo = Get-AzureSubscription -Current
$subName = $subscriptionInfo | %{ $_.SubscriptionName }

Set-AzureSubscription -SubscriptionName $subName –CurrentStorageAccount $storageAccountName

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