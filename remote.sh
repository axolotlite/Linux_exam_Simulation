#!/bin/bash

source environments/hosts.env

CURRENT_HOSTNAME="HOSTNAME_1"
CURRENT_HOST="HOST_1"
CURRENT_ADDRESS="ADDRESS_1"
USER="root"
PUBKEY="credentials/utility.pub"
PRIKEY="credentials/utility"
let count=1
transfer_credentials() {
	address=$1
	echo "Transferring public ssh-key for user $USER at $address..."
	ssh-copy-id -i $PUBKEY -f $USER@$address
	if [[ $(ls credentials/certs/* &> /dev/null) ]]
	then
		scp -i $PRIKEY credentials/certs/* $USER@$address:/etc/pki/ca-trust/source/anchors/
		ssh -i $PRIKEY $USER@$address "update-ca-trust"
	fi
}
setup_host() {
	number="$1"
	var_dir="environments/server_$number/scripts"
	address="$2"
	echo "setting up scripts for user $USER at $adddress..."
	for varfile in $(ls $var_dir)
	do
		script="scripts/${varfile%.*}.sh"
		echo "executing $script"
		cat "$var_dir/$varfile" "$script" | ssh -i $PRIKEY $USER@$address "bash -s "
#		read -p "continue? " empy
		#echo $varfile:$script
	done
}
grade_host() {
	number="$1"
	var_dir="environments/server_$number/problems"
	echo "grading ${!CURRENT_HOSTNAME}..."
	for varfile in $(ls $var_dir)
	do
		script="problems/${varfile%.*}.sh"
		echo "problem... "
		echo "$var_dir/$varfile" "$script" 
		cat "$var_dir/$varfile" "$script" | ssh -i $PRIKEY $USER@${!CURRENT_ADDRESS} "bash -s "
		read -p "press enter to move onto the next problem..." empy
	done
}
while [[ -n ${!CURRENT_HOSTNAME} ]]
do
#	echo "$CURRENT_HOSTNAME:${!CURRENT_HOSTNAME}"
#	echo "$CURRENT_ADDRESS:${!CURRENT_ADDRESS}"
#	echo "$CURRENT_HOST:${!CURRENT_HOST}"
	#transfer_credentials ${!CURRENT_ADDRESS}
	#setup_host $count ${!CURRENT_ADDRESS}
	grade_host $count
	((count++))
	CURRENT_HOSTNAME="HOSTNAME_$count"
	CURRENT_HOST="HOST_$count"
	CURRENT_ADDRESS="ADDRESS_$count"
done