#!/bin/bash
#this checks the logical volumes
VGNAME="datastore"
LVNAME="database"
FSTYPE="ext3"
EXTENT_NUM=50
EXTENT_SIZE="8.00"
MOUNT_POINT="/mnt/database"
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
