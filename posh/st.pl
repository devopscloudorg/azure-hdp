#This script executes at startup and detrermine a new drive needs to be attached
#If a new drive is found it attaches it to the virtual machine

#!/usr/bin/perl
use strict;
use warnings;
#use List::Uniq ':all';
use IPC::System::Simple qw(capture);
use IPC::System::Simple qw(run);
use Time::Format qw(%time %strftime %manip);
use List::MoreUtils 'any';

#this function returns current date in YYYY, MM and D format
sub local_yyyymmdd {
  my $time = shift || time();
  my ($year, $month, $mday) = (localtime($time))[5,4,3];
  return 10_000*($year + 1900) + 100*($month + 1) + $mday;
}

my $logfile = sprintf("%s.txt",local_yyyymmdd());

# Set up logging.
open  LOG, ">$logfile" || die "$0: Can't open log file!";
open ( STDERR, ">>$logfile" );
open ( STDOUT, ">>$logfile" );
select( LOG );
$| = 1; # Turn on buffer autoflush for log output
select( STDOUT );

#base directory where the new drives will be mounted
my $drivebasedir = "/grid";

print "################################################################\n";
print "Script $0 Started at $time{'yyyymmdd.hhmmss'}\n";
print "################################################################\n";

#read dmesg to see which disks are available
#scsi disks are named [sdx]
my @sd = ();
open(IN, "dmesg | ") || die "Failed to read demsg output: $!\n" ;
while(<IN>)
{
	if($_ =~ m/\[(sd[a-z])\]/) 
	{ 
		#if a disk if found add it to the @sd array
		push @sd, $1;
	}
}
close IN;

#sort the disk names and remove duplicates
my @list = sort(@sd);
my @unique;
my $i=0;

$unique[0] = $list[0];

foreach my $item(@list) {
    unless($item eq $unique[$i]) {
        push(@unique,$item);
        $i++;
    }
}

#remove after debugging
print "writing the unique sd values\n";
foreach(@unique)
{
 print "$_\n";
}

#determine which disks are mounted
open(IN,"mount | grep sd |") || die "Failed to read Mount Ouput: $!\n";

my @mount = ();

print "Mount | grep sd output is\n";
#read the output of mount and add it the @mount list
while(<IN>)
{
	push @mount, $_;
	print "$_";
}

close IN;

my $match_found;

#based on disks found from dmesg and mounted disks we will determine if any new
#disks need to be mounted.
my $unique = "";
my $mount = "";
my @newdrives;

foreach $unique(@unique)
{
	print "determining if drive $unique has been mounted\n";
	$match_found = any { /$unique/ } @mount;
	print "match found value is $match_found\n";
	if(!$match_found)
	{
		print "Drive $unique needs to be formatted and mounted\n";
		push @newdrives, $unique;
	}
}#end of foreach $unique

#check to see if there are any drives that need to be mounted 
my $newdrivecount = @newdrives;
my $newdrivename;

print "Number of new drives found is:$newdrivecount\n";

if($newdrivecount > 0)
{
	#mount the drives
	if(!-d $drivebasedir)
	{
		mkdir $drivebasedir;
		die "Cannot create directory $drivebasedir : $!\n" unless -d $drivebasedir;	
	}	

#we use the number of files in the directory to derive names of the new directories
	my $dir = "$drivebasedir/*";
	my @files = glob( $dir );
	my $filecount = @files;
	print "File count in $drivebasedir is $filecount\n";
	my $filesys = "";
	my $device = "";

	#For each drive that needs to be formatted/mounted do
	foreach $newdrivename(@newdrives)
	{
		$filecount = $filecount + 1;

		#generate unique name of the new drive being mounted
		$filesys = "$drivebasedir/$filecount";
		$device = "/dev/$newdrivename";
		print "creating file system:$filesys \n";
		my $return = capture("mkfs.ext4 -F -q $device");

		print "creaing directory $filesys\n";
		mkdir $filesys;
		die "Cannot create directory $filesys : $!\n" unless -d $filesys;	

		print "adding entry to fstab file\n";
		$return = capture("echo \"$device		$filesys			ext4	defaults	0 0\" >> /etc/fstab");

		print "mounting all drives\n";
		$return = capture("mount -a");

         	run("tail","/etc/fstab");     # Execute command without shell
	}#end of foreach $newdrivename
}
else
{
	print "No new drives found\n";
}

print "################################################################\n";
print "Script $0 Finished at $time{'yyyymmdd.hhmmss'}\n";
print "################################################################\n";
