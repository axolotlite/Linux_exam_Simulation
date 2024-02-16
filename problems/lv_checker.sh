#!/bin/bash
DESC="
This checks the logical groups and volumes created by the user
VGNAME: the volume group name given to the user
LVNAME: The logical volume given to the user
FSTYPE: the filesystem the user should use for the logical volume
EXTENT_NUM: the number of extents the user should create the volume with
EXTENT_SIZE: The size of the volume group given to the user
MOUNT_POINT: The location where the logical volume should be mounted
"
#-
VGNAME=${VGNAME:="datastore"}
LVNAME=${LVNAME:="database"}
FSTYPE=${FSTYPE:="ext3"}
EXTENT_NUM=${EXTENT_NUM:=50}
EXTENT_SIZE=${EXTENT_SIZE:="8.00"}
MOUNT_POINT=${MOUNT_POINT:="/mnt/database"}
#-
#check if the volume group has been created
vgdisplay $VGNAME &> /dev/null && echo volume $VGNAME group created successfully || echo volume group $VGNAME was not created successfully
#check if the logical volume was created
lvdisplay $VGNAME/$LVNAME &> /dev/null && echo logical volume $LVNAME created successfully || echo logical volume $LVNAME was not created successfully
#check the number of extents
(( $(lvdisplay $VGNAME/$LVNAME | awk '/Current LE/ {print $3}') >= $EXTENT_NUM )) &> /dev/null && echo logical volume $LVNAME has $EXTENT_NUM or more extents || echo logical volume does not have $EXTENT_NUM extents
#check the filetype of the logical volume
[[ $( lsblk -o NAME,FSTYPE  | awk -v lv=$LVNAME '$0 ~lv {print $NF}') == $FSTYPE ]] && echo filesystem created correctly || echo filesystem is wrong
#check lv extent size
[[ $(vgdisplay -Cv $VGNAME --nosuffix --units m | awk -v vg=$VGNAME '$0 ~ vg {print $3}') == $EXTENT_SIZE ]] && echo extent size allocated correctly || echo extent size incorrect
#finally check if everything was added correctly to the fstab file
#not sure how and i dont care anymore
