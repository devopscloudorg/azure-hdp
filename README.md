azure-hdp
=========

Scripts to Automate HDP deployment on Windows Azure Virtual Machines(Linux)

docs Directory contains documentation you can use to execute the scripts.

posh Diretory contains the PowerShell scripts you can use to provision HDP Cluster on Linux VM's

bash Directory contians the bash scripts you can use to provision HDP Cluster on Linux VM's



If you prefer PowerShell you can follow the instructions located in docs\Hadoop on Azure Virtual Machines Process.pdf


If  you development PC is MAC/Linux or if you prefer bash scripting over PowerShell you can follow the detailed instructions at docs\Hadoop on Azure Virtual Machines Process CLI.pdf

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


