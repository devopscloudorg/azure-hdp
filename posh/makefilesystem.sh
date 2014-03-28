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
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sdb > /var/log/mkfs.$sdb
	mkdir -p /drive/0
	mount /dev/$sdb /drive/0
	echo "/dev/$sdb /drive/0 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdc ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sdc > /var/log/mkfs.$sdc
	mkdir -p /drive/1
	mount /dev/$sdc /drive/1
	echo "/dev/$sdc /drive/1 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdd ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sdd > /var/log/mkfs.$sdd
	mkdir -p /drive/2
	mount /dev/$sdd /drive/2
	echo "/dev/$sdd /drive/2 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sde ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sde > /var/log/mkfs.$sde
	mkdir -p /drive/3
	mount /dev/$sde /drive/3
	echo "/dev/$sde /drive/3 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdf ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sdf > /var/log/mkfs.$sdf
	mkdir -p /drive/4
	mount /dev/$sdf /drive/4
	echo "/dev/$sdf /drive/4 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdg ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sdg > /var/log/mkfs.$sdg
	mkdir -p /drive/5
	mount /dev/$sdg /drive/5
	echo "/dev/$sdg /drive/5 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdh ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sdh > /var/log/mkfs.$sdh
	mkdir -p /drive/6
	mount /dev/$sdh /drive/6
	echo "/dev/$sdh /drive/6 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdi ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sdi > /var/log/mkfs.$sdi
	mkdir -p /drive/7
	mount /dev/$sdi /drive/7
	echo "/dev/$sdi /drive/7 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdj ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sdj > /var/log/mkfs.$sdj
	mkdir -p /drive/8
	mount /dev/$sdj /drive/8
	echo "/dev/$sdj /drive/8 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdk ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sdk > /var/log/mkfs.$sdk
	mkdir -p /drive/9
	mount /dev/$sdk /drive/9
	echo "/dev/$sdk /drive/9 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdl ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sdl > /var/log/mkfs.$sdl
	mkdir -p /drive/10
	mount /dev/$sdl /drive/10
	echo "/dev/$sdl /drive/10 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdm ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sdm > /var/log/mkfs.$sdm
	mkdir -p /drive/11
	mount /dev/$sdm /drive/11
	echo "/dev/$sdm /drive/11 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdn ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sdn > /var/log/mkfs.$sdn
	mkdir -p /drive/12
	mount /dev/$sdn /drive/12
	echo "/dev/$sdn /drive/12 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdo ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sdo > /var/log/mkfs.$sdo
	mkdir -p /drive/13
	mount /dev/$sdo /drive/13
	echo "/dev/$sdo /drive/13 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdp ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sdp > /var/log/mkfs.$sdp
	mkdir -p /drive/14
	mount /dev/$sdp /drive/14
	echo "/dev/$sdp /drive/14 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdq ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sdq > /var/log/mkfs.$sdq
	mkdir -p /drive/15
	mount /dev/$sdq /drive/15
	echo "/dev/$sdq /drive/15 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdr ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sdr > /var/log/mkfs.$sdr
	mkdir -p /drive/16
	mount /dev/$sdr /drive/16
	echo "/dev/$sdr /drive/16 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sds ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sds > /var/log/mkfs.$sds
	mkdir -p /drive/17
	mount /dev/$sds /drive/17
	echo "/dev/$sds /drive/17 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdt ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sdt > /var/log/mkfs.$sdt
	mkdir -p /drive/18
	mount /dev/$sdt /drive/18
	echo "/dev/$sdt /drive/18 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdu ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sdu > /var/log/mkfs.$sdu
	mkdir -p /drive/19
	mount /dev/$sdu /drive/19
	echo "/dev/$sdu /drive/19 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdv ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sdv > /var/log/mkfs.$sdv
	mkdir -p /drive/20
	mount /dev/$sdv /drive/20
	echo "/dev/$sdv /drive/20 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdw ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sdw > /var/log/mkfs.$sdw
	mkdir -p /drive/21
	mount /dev/$sdw /drive/21
	echo "/dev/$sdw /drive/21 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdx ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sdx > /var/log/mkfs.$sdx
	mkdir -p /drive/22
	mount /dev/$sdx /drive/22
	echo "/dev/$sdx /drive/22 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdy ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sdy > /var/log/mkfs.$sdy
	mkdir -p /drive/23
	mount /dev/$sdy /drive/23
	echo "/dev/$sdy /drive/23 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

if	[[ $sdz ]]
then	echo "y
	" | mkfs.$FISYS -m 1 -O dir_index,extent,sparse_super -E lazy_itable_init /dev/$sdz > /var/log/mkfs.$sdz
	mkdir -p /drive/24
	mount /dev/$sdz /drive/24
	echo "/dev/$sdz /drive/24 $FISYS defaults 0 0" >> /etc/fstab
else	echo ""
fi

	echo "
	"
	echo "We're checking the disks:"
	fdisk -l | grep /dev/sd > /var/log/automountandformat.log
	sleep 2 ; if ls /var/log/ | grep auto > /dev/null ; then echo "Done." ; fi

	echo "We're checking our mounts:"
	mount -l | grep /drive >> /var/log/automountandformat.log
	sleep 2 ; if ls /var/log/ | grep auto > /dev/null ; then echo "Done." ; fi

	echo "And we're checking /etc/fstab for our mounts:"
	cat /etc/fstab | grep /drive >> /var/log/automountandformat.log	
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
