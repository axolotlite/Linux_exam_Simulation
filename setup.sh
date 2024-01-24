#!/bin/bash
#this is the script responsible for delivering the setup scripts, hostname info, ssh keys and problems to each VM
#user inputted info
HOSTS="environments/hosts.env"
#CLASSROOM_ADDRESS=""
#LAB_A_ADDRESS=""
#LAB_B_ADDRESS=""
#validate ip address
validate_ip () {
	[[ "$1" =~ ^(([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))\.){3}([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))$ ]]
}
help () {
echo "This is the help message, god help me. (and you)
-h is for help, it displays this message
-i classroom_ip,lab_a_ip,lab_b_ip this begins initializing the labs using the ssh keys
"
}
#while getopts ":h:i:" option; do
#	case $option in
#		h) 
#			help
#			exit;;
#		i)
#			addresses=$OPTARG
#			echo $artful
#			;;
#		\?)
#			echo "Error: Invalid Option"
#			exit;;
#	esac
#done
#validate_ip $1 && echo success || echo failure
#greeting
#
echo "Welcome to the delivery script, this script will uses the ip addresses placed in environments/general.env"
echo "Setting up labs..."
source $HOSTS
#openssl req -subj "/CN=$CLASSROOM_HOSTNAME/O=Mock Exam/C=EG" -newkey rsa:4096 -nodes -sha256 -keyout credentials/domain.key -x509 -days 365 -out credentials/domain.crt
#first moving the key to each vm
for address in $CLASSROOM_ADDRESS $LAB_A_ADDRESS $LAB_B_ADDRESS;
do
	user=root
#	read -rp "username for $address: " user
	ssh-copy-id -i credentials/utility.pub -f $user@$address || ( echo "copying keys failure, exitting..."; exit 1 )
	#setup the hosts file
	cat $HOSTS scripts/setup_hosts.sh | ssh -i credentials/utility $user@$address "bash -s "
done
#setup the classroom
ssh -i credentials/utility $user@$CLASSROOM_ADDRESS "mkdir -p /opt/registry/{auth,certs,data} /root/.workdir"
#scp -i credentials/utility credentials/domain.* root@$CLASSROOM_ADDRESS:/opt/registry/certs/
scp -i credentials/utility patches/* root@$CLASSROOM_ADDRESS:/root/.workdir/
cat $HOSTS scripts/setup_repo.sh scripts/setup_classroom.sh | ssh -i credentials/utility $user@$CLASSROOM_ADDRESS "bash -s "
#setup lab a
cat $HOSTS scripts/setup_lab_a.sh | ssh -i credentials/utility $user@$LAB_A_ADDRESS "bash -s "

#setup lab b
scp -i credentials/utility $user@$CLASSROOM_ADDRESS:/opt/registry/certs/domain.crt $user@$LAB_B_ADDRESS:/etc/pki/ca-trust/source/anchors/
cat $HOSTS scripts/setup_lab_b.sh | ssh -i credentials/utility $user@$LAB_B_ADDRESS "bash -s "
