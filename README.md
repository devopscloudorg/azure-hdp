azure-hdp
=========

Scripts to Automate HDP deployment on Windows Azure Virtual Machines(Linux)

The focus on the current version is to automate creation of the infrastructure. Future versions will include best practices for disk alignment to optimize for most applications.

docs Directory contains documentation you can use to execute the scripts.

posh Diretory contains the PowerShell scripts you can use to provision HDP Cluster on Linux VM's

bash Directory contians the bash scripts you can use to provision HDP Cluster on Linux VM's


##PowerShell to deploy the infrastructure
If you prefer PowerShell you can follow the instructions located in docs\Hadoop on Azure Virtual Machines Process.pdf
High level steps will be added here...
1.	Create the Management Node: Execute 1_Management_Node.ps1
	a.	Create the Affinity Group (if it doesn’t exist)
	b.	Create the Virtual Network (if it doesn’t exist)
	c.	Create the Storage Account (if it doesn’t exist)
	d.	Create the Management virtual machine
2.	Create the Master Node: Execute 2_Master_Node.ps1
3.	Manually configure the Management and Master nodes
	a.	Set root passwords
	b.	Set up passwordless SSH between the Management Node and the Master Node
	c.	Set various server configurations to meet HDP requirements 
	d.	Add disk mount script
4.	Prepare the Master Node for provisioning
	a.	Update waagent.conf 
	b.	Run waagent –deprovision 
5.	Create the Windows Azure Master Image
	a.	Stop the Master Node
	b.	Capture an image
6.	Execute 3_Cluster_Nodes
	a.	Creates multiple Windows Azure Virtual Machines using the Master Node image
7.	Update /etc/hosts and mount drives
8.	Install Ambari on Management Node
9.	Install HDP using Ambari


##Azure CLI and Bash Scripts
If  your development PC is MAC/Linux or if you prefer Azure CLI over PowerShell you can follow the detailed instructions at docs\Hadoop on Azure Virtual Machines Process CLI.pdf

High level instructions are using bash scripts to configure HDP are shown below.

1.	Update the hdpsetup.sh file with information about your HDP setup
2.	Execute createmgmtnode.sh
  a.	Create the storage account
  b.	Create the Affinity Group
  c.	Create the Virtual Network
  d.	Create the Management Node
3.	Execute createmasterimage.sh. This step is only necessary if you are creating a new customer image for your nodes.
  a.	Create the Master Node
4.	Manually configure the Management
  a.	Attach disk 
  b.	Set root passwords
  c.	Set up passwordless SSH between the Management Node and the Master Node
  d.	Set various server configurations to meet HDP requirements 
  e.	Update host files 
5.	Manually configure the Master Node
  a.	Attach disk (Management Node only)
  b.	Set root passwords
  c.	Set up passwordless SSH between the Management Node and the Master Node
  d.	Set various server configurations to meet HDP requirements 
  e.	Update host files 
6.	Prepare the Master Node for provisioning
  a.	Update waagent.conf (Master Node only)
  b.	Run waagent –deprovision (Master Node only)
7.	Create the Windows Azure Image
  a.	Stop the Master Node
  b.	Capture an image
8.	Update hdpsetup.sh nodeImageName with the name of the captured image.
9.	Execute createclusternode.sh
  a.	Creates multiple Windows Azure Virtual Machines using the Master Node image
  b.	Creates the script mountdrive.sh which mounts data drives on each node in the cluster
  c.	Creates the script updatehosts.sh which updates /etc/hosts file on each node in the cluster
10.	Run the script updatehosts.sh to update /etc/hosts
11.	Run the script mountdrive.sh
12.	Install Ambari on Management Node
13.	Install HDP using Ambari

###hdpsetup.sh
This settings file stores all the settings related to HDP cluster you are setting up. All other scripts refer to the settings in this file.

###createmgmtnode.sh
This script creates the management node which is the first node in the cluster.
This is the node that is used to install HDP. This node has an ability to do password less setup
to all other nodes in the cluster. You invoke this script without any arguments.

###createmasterimage.sh
This script creates the master node. It is manually configured with any HDP related settings.
We capture an image of this node and delete this virtual machine. All other nodes in the HDP cluster
are created from this image. You invoke tihs script without any arguments.

###createclusternodes.sh
This script creates all the nodes except the management nodes in the HDP cluster. It reads all the details from hdpsetup.sh file. You invoke this script without any arguments

###updateshosts.sh
This script is used to update the /etc/hosts file with names and ip addresses of all the nodes in the cluster
It also relies on hdpsetup.sh file and can be invoked without any command line arguments.

###deletecluster.sh
This script reads cluster details from hdpsetup.sh and deletes all the virtual machines and cloud sevices from the cluster. It can be invoked without any arguments.

###makefilesystem.sh
This script looks for any newly added drives to the VM and mounts these drives. It is scheduled to run at each reboot.
If you add new drives and don't reboot you will need to run this script manually


