#!/bin/bash

source environments/hosts.env

CURRENT_HOSTNAME="HOSTNAME_1"
CURRENT_HOST="HOST_1"
CURRENT_ADDRESS="ADDRESS_1"
USER="root"
PUBKEY="credentials/utility.pub"
PRIKEY="credentials/utility"
HELP="you have 3 options:\ntransfer\twhich will transport the ssh public keys to the hosts in the hosts.env file, this should be run first\nsetup\t which will setup all the setup scripts you've added through var_setter\ngrade\twhich will run all the problem scripts you've added through var setter."
DEBUG=false
let count=1
transfer_credentials() {
	address="${!CURRENT_ADDRESS}"
	echo "Transferring public ssh-key for user $USER at $address..."
	ssh-copy-id -i $PUBKEY -f $USER@$address
	if [[ $(ls credentials/certs/* &> /dev/null) ]]
	then
		scp -i $PRIKEY credentials/certs/* $USER@$address:/etc/pki/ca-trust/source/anchors/
		ssh -i $PRIKEY $USER@$address "update-ca-trust"
	fi
}
setup_host() {
	number="$count"
	var_dir="environments/server_$number/scripts"
	address="${!CURRENT_ADDRESS}"
	echo "setting up scripts for user $USER at $adddress..."
	for varfile in $(ls $var_dir)
	do
		script="scripts/${varfile%.*}.sh"
		[[ $DEBUG == "true" ]] && read -p "press enter to continue executing $script... " empy
		echo "executing $script"
		cat "$var_dir/$varfile" "$script" | ssh -i $PRIKEY $USER@$address "bash -s "
		#echo $varfile:$script
	done
}
grade_host() {
	number="$count"
	address="${!CURRENT_ADDRESS}"
	var_dir="environments/server_$number/problems"
	echo "grading ${!CURRENT_HOSTNAME}..."
	for varfile in $(ls $var_dir)
	do
		script="problems/${varfile%.*}.sh"
		echo "problem... "
		echo "$var_dir/$varfile" "$script" 
		cat "$var_dir/$varfile" "$script" | ssh -i $PRIKEY $USER@$address "bash -s "
		read -p "press enter to move onto the next problem..." empy
	done
}
help_func() {
	
	echo -e $HELP
	exit 1
}
while getopts "tsghv" opt
do
	case $opt in
		t)
			opt_func=transfer_credentials
			;;
		s)
			opt_func=setup_host
			;;
		g)
			opt_func=grade_host
			;;
		v)
			DEBUG=true
			;;
		h)

			help_func
			exit 1
			;;
		*)
			help_func
			exit 1
			;;
	esac


done
while [[ -n ${!CURRENT_HOSTNAME} ]]
do
#	echo "$CURRENT_HOSTNAME:${!CURRENT_HOSTNAME}"
#	echo "$CURRENT_ADDRESS:${!CURRENT_ADDRESS}"
#	echo "$CURRENT_HOST:${!CURRENT_HOST}"
	#transfer_credentials ${!CURRENT_ADDRESS}
	#setup_host $count ${!CURRENT_ADDRESS}
	$opt_func
	((count++))
	CURRENT_HOSTNAME="HOSTNAME_$count"
	CURRENT_HOST="HOST_$count"
	CURRENT_ADDRESS="ADDRESS_$count"
done
