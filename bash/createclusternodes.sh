#!/bin/bash
#Creates the nodes in the cluster from a custom image
#Expectation is that affinity group, storage account, virtual network have already been setup

source ./hdpsetup.sh

#This script requires jq json processor
#check to see if jq is available and download it if necessary
result=$(which jq)
if [[ -z $result ]]; then
	wget http://stedolan.github.io/jq/download/linux64/jq
	sudo chmod +x jq
	sudo mv jq /usr/local/bin
else
	printf "jq json processor was found\n"
fi

(which jq) || { echo "jq json processor is not available"; exit 1; } 

##############################################################
## Create affinity group if it does not exist
##############################################################

printf "affinty group name is %s, affinity group location is %s\n" "$affinityGroupName" "$affinityGroupLocation"

result=$(azure account affinity-group show "$affinityGroupName" --json | jq '.Name')   
if [[ -z $result ]]; then
	(azure account affinity-group create --location "$affinityGroupLocation" "$affinityGroupName") || { echo "Failed to create affinity group $affinityGroupName"; exit 1; }
else
	echo "affinity group $affinityGroupName exists"
fi

#show the affinity group details
printf "######################################## Affinity Group Details #######################################\n"
azure account affinity-group show "$affinityGroupName" --json

##############################################################
## Create storage account if it does not exist
##############################################################

printf "storage account name is %s\n" "$storageAccount"

result=$(azure storage account show "$storageAccount" --json | jq '.ServiceName')   
if [[ -z $result ]]; then
	(azure storage account create --affinity-group "$affinityGroupName" $storageAccount) || { echo "Failed to create storage account $storageAccount"; exit 1; }
else
	echo "Storage account $storageAccount exists"
fi

#show the storage account details
printf "######################################## Storage Account Details #######################################\n"
azure storage account show "$storageAccount" --json

##############################################################
## Create virtual network if it does not exist
##############################################################

printf "virtual network is %s, subnet is %s\n" "$vnetName" "$subnetName"

result=$(azure network vnet show $vnetName --json | jq '.Name')   
if [[ -z $result ]]; then
	printf "Need to create virtual network %s\n" "$vnetName"
	(azure network vnet create --vnet $vnetName --affinity-group "$affinityGroupName" --address-space $vnetAddressSpace --cidr $vnetCidr --subnet-name $subnetName --subnet-start-ip $subnetAddressSpace --subnet-cidr $subnetCidr) || { echo "Failed to create virtual network $vnetName"; exit 1;}
else
	printf "Virtual network $virtualNetworkName exists\n"
fi

#show the virtual network details
printf "######################################## Virtual Network Details #######################################\n"
azure network vnet show "$vnetName" --json

#Loop to create nodes in the cluster
loopIndex=1
while [ $loopIndex -le $nodeCount ]; do


	##############################################################
	## Create the management node if it does not exist
	##############################################################
	vmName=$vmNamePrefix"$loopIndex"
	cloudServiceName=$cloudServicePrefix"$loopIndex"
	dnsName=$cloudServiceName".cloudapp.net"

	#Check to see if the cloud servide already exists
	result=$(azure service show $cloudServiceName --json | jq '.ServiceName')
	if [[ -z $result ]]; then
        	printf "Service does not exist. About to create cloud service:$cloudServiceName in affinity group:$affinityGroupName\n"
        	(azure service create --affinitygroup "${affinityGroupName}" --serviceName $cloudServiceName) || { echo "Failed to create Cloud Service $cloudServiceName"; exit 1; }
	else
		printf "Cloud Service $cloudServiceName exists\n"
	fi

	#show the cloud service details
	printf "######################################## Cloud Service Details #######################################\n"
	azure service show "$cloudServiceName" --json

	#Check to see if the VM already exists
	result=$(azure vm show $vmName --json | jq '.VMName')
	if [[ -z $result ]]; then

        	printf "Virtual machine $vnName does not exist. Creating ...\n" 
		#create the vm and attach data disks
	(	azure vm create --vm-size $nodeSize --vm-name $vmName --ssh 22 --virtual-network-name $vnetName --subnet-names $subnetName $dnsName $nodeImageName $adminUserName $adminPassword) || { echo "Failed to create vm $vmName"; exit 1;}

		#add all the necessary data disks
		index=0
		while [ $index -lt $numOfDisks ]; do
			azure vm disk attach-new --verbose $vmName $diskSizeInGB
			let index=index+1
		done
	

	else
		printf "Virtual machine $vmName exists\n"
	fi

	#We can either add the adminUserName in the SUDOER group so it can overwrite the /etc/hosts file
	#or we can use the root user to overwrite the /etc/hosts file
	#echo "scp /etc/hosts ${adminUserName}@${vmName}:/etc" >> $mntscript
	#echo "ssh ${adminUserName}@${vmName}:/root/scripts/st.pl" >> $mntscript
	echo "ssh root@${vmName} /root/scripts/makefilesystem.sh" >> $mntscript
	echo "scp /etc/hosts root@${vmName}:/etc" >> $mntscript

	printf "######################################## Virtual Machine Details #######################################\n"
	#display the details about the newly created VM
	ipaddress=$(azure vm show $vmName --json | jq '.IPAddress')
	#remove the double quotes from the IP address
	echo "$ipaddress $vmName" | sed -e 's/\"//g' >> $hostsfile

	let loopIndex=loopIndex+1
done
#make the mntscript executable
chmod a+x $mntscript
