<#############################################################################################################
Hadoop on Azure Virtual Machines

.SYNOPSIS 
  Used to automate the creation of an image from a virtual machine.  

.EXAMPLE 
  .\0_Capture_Image.ps1 -cloudServiceName "hadoopazurec" -vmName "hadoopazurec" -imageName "hadoopazurec" -imageLabel "Hadoop Clone"

############################################################################################################>

param(
    # The name of the cloud service. 
    [Parameter(Mandatory = $true)]  
    [string]$cloudServiceName, 

    # The name of the vm. 
    [Parameter(Mandatory = $true)]  
    [string]$vmName, 
    
    # The name of the new image. 
    [Parameter(Mandatory = $true)]  
    [string]$imageName,

    # The label for the new image. 
    [Parameter(Mandatory = $true)]  
    [string]$imageLabel
    ) 


###########################################################################################################
#Stop the virtual machine.
########################################################################################################### 
Get-AzureVM | where {$_.Name -eq $vmName} | Stop-AzureVM -Force


###########################################################################################################
## Create an image from the new vhd file in the images container.
########################################################################################################### 
Save-AzureVMImage -ServiceName $cloudServiceName -Name $vmName -ImageName $imageName -ImageLabel $imageLabel -OSState 'Generalized'

