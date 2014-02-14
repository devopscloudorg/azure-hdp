#!/bin/bash

## A little widgetty thing knocked together to create partitions & filesystems
## on Linux machines.
## Author: (as if I'm proud of this!) Ben Watson
## Twitter: @WhatsOnStorage


# Setting some variables to allow quick customisation:
FISYS="ext4"

####----------------------------------------------------------------------####
##--------------------------B----A----S----H----Y---------------------------##
####----------------------------------------------------------------------####

dmesg | grep -e "\[sd[a-z]" | awk '{print $3;}' | sort -u > /tmp/diskdeviceoutput

sdb=$(cat /tmp/diskdeviceoutput | grep -o sdb)
sdc=$(cat /tmp/diskdeviceoutput | grep -o sdc)
sdd=$(cat /tmp/diskdeviceoutput | grep -o sdd)
sde=$(cat /tmp/diskdeviceoutput | grep -o sde)
sdf=$(cat /tmp/diskdeviceoutput | grep -o sdf)
sdg=$(cat /tmp/diskdeviceoutput | grep -o sdg)
sdh=$(cat /tmp/diskdeviceoutput | grep -o sdh)
sdi=$(cat /tmp/diskdeviceoutput | grep -o sdi)
sdj=$(cat /tmp/diskdeviceoutput | grep -o sdj)
sdk=$(cat /tmp/diskdeviceoutput | grep -o sdk)
sdl=$(cat /tmp/diskdeviceoutput | grep -o sdl)
sdm=$(cat /tmp/diskdeviceoutput | grep -o sdm)
sdn=$(cat /tmp/diskdeviceoutput | grep -o sdn)
sdo=$(cat /tmp/diskdeviceoutput | grep -o sdo)
sdp=$(cat /tmp/diskdeviceoutput | grep -o sdp)
sdq=$(cat /tmp/diskdeviceoutput | grep -o sdq)
sdr=$(cat /tmp/diskdeviceoutput | grep -o sdr)
sds=$(cat /tmp/diskdeviceoutput | grep -o sds)
sdt=$(cat /tmp/diskdeviceoutput | grep -o sdt)
sdu=$(cat /tmp/diskdeviceoutput | grep -o sdu)
sdv=$(cat /tmp/diskdeviceoutput | grep -o sdv)
sdw=$(cat /tmp/diskdeviceoutput | grep -o sdw)
sdx=$(cat /tmp/diskdeviceoutput | grep -o sdx)
sdy=$(cat /tmp/diskdeviceoutput | grep -o sdy)
sdz=$(cat /tmp/diskdeviceoutput | grep -o sdz)


if cat /etc/mtab | grep sdb
then unset $sdb
fi

if cat /etc/mtab | grep sdc
then unset $sdc
fi

if cat /etc/mtab | grep sdd
then unset $sdd
fi

if cat /etc/mtab | grep sde
then unset $sde
fi

if cat /etc/mtab | grep sdf
then unset $sdf
fi

if cat /etc/mtab | grep sdg
then unset $sdg
fi

if cat /etc/mtab | grep sdh
then unset $sdh
fi

if cat /etc/mtab | grep sdi
then unset $sdi
fi

if cat /etc/mtab | grep sdj
then unset $sdj
fi

if cat /etc/mtab | grep sdk
then unset $sdk
fi

if cat /etc/mtab | grep sdl
then unset $sdl
fi

if cat /etc/mtab | grep sdm
then unset $sdm
fi

if cat /etc/mtab | grep sdn
then unset $sdn
fi

if cat /etc/mtab | grep sdo
then unset $sdo
fi

if cat /etc/mtab | grep sdp
then unset $sdp
fi

if cat /etc/mtab | grep sdq
then unset $sdq
fi

if cat /etc/mtab | grep sdr
then unset $sdr
fi

if cat /etc/mtab | grep sds
then unset $sds
fi

if cat /etc/mtab | grep sdt
then unset $sdt
fi

if cat /etc/mtab | grep sdu
then unset $sdu
fi

if cat /etc/mtab | grep sdv
then unset $sdv
fi

if cat /etc/mtab | grep sdw
then unset $sdw
fi

if cat /etc/mtab | grep sdx
then unset $sdx
fi

if cat /etc/mtab | grep sdy
then unset $sdy
fi

if cat /etc/mtab | grep sdz
then unset $sdz
fi


if
	[[ $sd{b-z} ]]
then
	echo "Success, $USER, we have some disks here, and we shall begin."
	echo "Fasten your seatbelts, we're going to be getting this milk float going into hyperspace!"
	sleep 3

cp /etc/fstab /etc/old.fstab`date +%d-%m-%y---%H-%M-%S`


if 	[[ $sdb ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sdb > /var/log/mkfs.$sdb
	mkdir -p /grid/0
	mount /dev/$sdb /grid/0
	echo "/dev/$sdb /grid/0 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdc ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sdc > /var/log/mkfs.$sdc
	mkdir -p /grid/1
	mount /dev/$sdc /grid/1
	echo "/dev/$sdc /grid/1 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdd ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sdd > /var/log/mkfs.$sdd
	mkdir -p /grid/2
	mount /dev/$sdd /grid/2
	echo "/dev/$sdd /grid/2 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sde ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sde > /var/log/mkfs.$sde
	mkdir -p /grid/3
	mount /dev/$sde /grid/3
	echo "/dev/$sde /grid/3 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdf ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sdf > /var/log/mkfs.$sdf
	mkdir -p /grid/4
	mount /dev/$sdf /grid/4
	echo "/dev/$sdf /grid/4 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdg ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sdg > /var/log/mkfs.$sdg
	mkdir -p /grid/5
	mount /dev/$sdg /grid/5
	echo "/dev/$sdg /grid/5 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdh ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sdh > /var/log/mkfs.$sdh
	mkdir -p /grid/6
	mount /dev/$sdh /grid/6
	echo "/dev/$sdh /grid/6 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdi ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sdi > /var/log/mkfs.$sdi
	mkdir -p /grid/7
	mount /dev/$sdi /grid/7
	echo "/dev/$sdi /grid/7 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdj ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sdj > /var/log/mkfs.$sdj
	mkdir -p /grid/8
	mount /dev/$sdj /grid/8
	echo "/dev/$sdj /grid/8 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdk ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sdk > /var/log/mkfs.$sdk
	mkdir -p /grid/9
	mount /dev/$sdk /grid/9
	echo "/dev/$sdk /grid/9 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdl ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sdl > /var/log/mkfs.$sdl
	mkdir -p /grid/10
	mount /dev/$sdl /grid/10
	echo "/dev/$sdl /grid/10 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdm ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sdm > /var/log/mkfs.$sdm
	mkdir -p /grid/11
	mount /dev/$sdm /grid/11
	echo "/dev/$sdm /grid/11 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdn ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sdn > /var/log/mkfs.$sdn
	mkdir -p /grid/12
	mount /dev/$sdn /grid/12
	echo "/dev/$sdn /grid/12 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdo ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sdo > /var/log/mkfs.$sdo
	mkdir -p /grid/13
	mount /dev/$sdo /grid/13
	echo "/dev/$sdo /grid/13 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdp ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sdp > /var/log/mkfs.$sdp
	mkdir -p /grid/14
	mount /dev/$sdp /grid/14
	echo "/dev/$sdp /grid/14 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdq ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sdq > /var/log/mkfs.$sdq
	mkdir -p /grid/15
	mount /dev/$sdq /grid/15
	echo "/dev/$sdq /grid/15 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdr ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sdr > /var/log/mkfs.$sdr
	mkdir -p /grid/16
	mount /dev/$sdr /grid/16
	echo "/dev/$sdr /grid/16 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sds ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sds > /var/log/mkfs.$sds
	mkdir -p /grid/17
	mount /dev/$sds /grid/17
	echo "/dev/$sds /grid/17 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdt ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sdt > /var/log.mkfs.$sdt
	mkdir -p /grid/18
	mount /dev/$sdt /grid/18
	echo "/dev/$sdt /grid/18 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdu ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sdu > /var/log/mkfs.$sdu
	mkdir -p /grid/19
	mount /dev/$sdu /grid/19
	echo "/dev/$sdu /grid/19 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdv ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sdv > /var/log/mkfs.$sdv
	mkdir -p /grid/20
	mount /dev/$sdv /grid/20
	echo "/dev/$sdv /grid/20 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdw ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sdw > /var/log/mkfs.$sdw
	mkdir -p /grid/21
	mount /dev/$sdw /grid/21
	echo "/dev/$sdw /grid/21 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdx ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sdx > /var/log/mkfs.$sdx
	mkdir -p /grid/22
	mount /dev/$sdx /grid/22
	echo "/dev/$sdx /grid/22 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdy ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sdy > /var/log/mkfs.$sdy
	mkdir -p /grid/23
	mount /dev/$sdy /grid/23
	echo "/dev/$sdy /grid/23 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdz ]]
then	echo "y
	" | mkfs.$FISYS /dev/$sdz > /var/log/mkfs.$sdz
	mkdir -p /grid/24
	mount /dev/$sdz /grid/24
	echo "/dev/$sdz /grid/24 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

	echo "
	"
	echo "We're checking the disks:"
	fdisk -l | grep /dev/sd > /var/log/automountandformat.log
	sleep 2 ; if ls /var/log/ | grep auto > /dev/null ; then echo "Done." ; fi

	echo "We're checking our mounts:"
	mount -l | grep /grid >> /var/log/automountandformat.log
	sleep 2 ; if ls /var/log/ | grep auto > /dev/null ; then echo "Done." ; fi

	echo "And we're checking /etc/fstab for our mounts:"
	cat /etc/fstab | grep /grid >> /var/log/automountandformat.log	
	sleep 2 ; if ls /var/log/ | grep auto > /dev/null ; then echo "Done." ; fi

	echo "
"

	echo "The above commands have outputted to a log file, at /var/log/automountandformat.log."
	sleep 3

	echo "
	"
	echo "And now, we're gone - (with a newsreader-style voice) back to you on the shell."
	echo "
	"
else	echo "Sorry $USER, we can't find any disks! Please check they are properly attached and re-run the script."
fi
