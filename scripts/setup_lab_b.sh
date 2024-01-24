#!/bin/bash
SHARE_DIR="/localhomes"
SHARE_USERS=( $(echo "production"{1..30}) )
SHARE_IDS="300"
USER="farah"
FILE_COUNT=10
FILES=()
#setup hostname
echo $LAB_A_HOST > /etc/hostname
#first we disable all the repos
find /etc/yum.repos.d/ -type f -exec sed -i 's/enabled=1/enabled=0/' {} \;
#setup hostname and adjacent hosts
bash -exec setup_hosts.sh
#setup the ssl cert for the container repository
openssl s_client -connect $CLASSROOM_HOSTNAME:5000 -servername $CLASSROOM_HOSTNAME &
update-ca-trust
#create the users
for idx in ${!SHARE_USERS[@]}
do
        user=${SHARE_USERS[idx]}
        uid="$SHARE_IDS$idx"
        useradd -p $(openssl passwd redhat ) -u $uid -U -d $SHARE_DIR/$user -m $user
        
done
#create random files owned by a user for one of the exercises
useradd -M $USER
find / -type d -mount -print0 2> /dev/null |
	shuf -zn $FILE_COUNT |
		while IFS= read -r -d "" dir; do
			file=$(sudo -u $USER mktemp)
                        echo $file | awk -F '/' '{print $NF}' >> $HOME/.filenames
			mv $file "$dir" && echo "moved file to $dir"
		done
#create a file for use in tar checking
mkdir -p /var/tmp/simple/directory/tree/
echo "success" > /var/tmp/simple/directory/tree/.verification		


