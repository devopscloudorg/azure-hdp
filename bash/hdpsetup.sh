#This settings file stores all the settings related to HDP cluster you are setting up
#Affinty group helps you keep your storage and compute in the same region
export affinityGroupName=myeasthdpag
#Name the region where affinity group should be created. 
#choices are valid values are "East US", "West US", "East Asia", "Southeast Asia", "North Europe", "West Europe"
export affinityGroupLocation="East US"

#name of the storage account here your virtual machines will be stored.
export storageAccount=myhdpstorage

#Name of the image you will use to create your virtual machines
#export imageName=b39f27a8b8c64d52b05eac6a62ebad85__Ubuntu_DAILY_BUILD-precise-12_04_3-LTS-amd64-server-20140204-en-us-30GB
export imageName=c290a6b031d841e09f2da759bbabe71f__Oracle-Linux-6

#Size of the Virtual machine. Valid sizes are extrasmall, small, medium, large, extralarge, a5, a6, a7
export instanceSize=large

#Size of the data disk you want to attach to the VM you are creating. You will typically attach at least 1 disk
export diskSizeInGB=1
#Number of disks you want to attach. Small VM can have 2 disks, medium can have 4, large can have 8 and extralarge can have 8 data disks
export numOfDisks=1

#virtual machine settings
export vmNamePrefix=yourhdpnode
export cloudServicePrefix=yourhdpsvc
#user admin name and password for the virtual machine you are creating
export adminUserName=azureuser
#Azure CLI enforces strong passwords uppercase, lower case and special characters
export adminPassword=Password.1!

#setting related to virtual network
export vnetName=myeasthdpvnet
#address space allows 192.168.0.0, 10.0.0.0 and 172.16.0.0 ip address ranges
#virtual network faq is here http://msdn.microsoft.com/en-us/library/windowsazure/dn133803.aspx
export vnetAddressSpace=172.16.0.0
export vnetCidr=16
export subnetName=mysubnet
export subnetAddressSpace=172.16.1.0
export subnetCidr=24

#These settings are for nodes in the HDP cluster
#Name of the custom image you will use to create your cluster nodes
#After you have create your master node image replace the value of nodeImageName wiht the image you created 
export nodeImageName=oraclehdp2
#Number of nodes in your HDP cluster
export nodeCount=2
#Size of the nodes in the hadoop cluster. Valid sizes are extrasmall, small, medium, large, extralarge, a5, a6, a7
export nodeSize=small

#This script will be generated and it will be used to mount data drives in each node in the cluster. It will also copy /etc/hosts file to each node
mntscript="mountdrive.sh"
#This file will generate hosts file that can be appended to /etc/hosts on each node.
hostsfile="hosts.txt"
