#!/bin/bash

source environments/hosts.env

CURRENT_HOSTNAME="HOSTNAME_1"
CURRENT_HOST="HOST_1"
CURRENT_ADDRESS="ADDRESS_1"
USER="root"
PUBKEY="credentials/utility.pub"
PRIKEY="credentials/utility"
DEBUG=false
FUNC_EXEC=true
CCOUNT=true
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
execute_script() {
	filename=$1
	address=$2
	directory=${filename%/*}
	directory=${directory##*/}
	filename=${filename##*/}
	filename=${filename%.*}
	varfile="environments/server_$count/$directory/$filename.vars"
	scriptfile="$directory/$filename.sh"
	#echo -e "directory: $directory\nfilename: $filename\nvarfile: $varfile\nscriptfile: $scriptfile\n----"
	cat "$varfile" "$scriptfile" | ssh -i $PRIKEY "$USER@${!CURRENT_ADDRESS}" "bash -s "
}
setup_host() {
	number="$count"
	var_dir="environments/server_$number/scripts"
	address="${!CURRENT_ADDRESS}"
	echo "setting up scripts for user $USER at $adddress..."
	for varfile in $(ls $var_dir)
	do
		#script="scripts/${varfile%.*}.sh"
		[[ $DEBUG == "true" ]] && read -p "press enter to continue executing $script... " empy
		echo "executing ${varfile#*/}"
#		cat "$var_dir/$varfile" "$script" | ssh -i $PRIKEY $USER@$address "bash -s "
		execute_script "$var_dir/$varfile" 
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
		#script="problems/${varfile%.*}.sh"
		echo "executing ${varfile#*/}"
		[[ $DEBUG == "true" ]] && read -p "press enter to continue executing $script... " empy
		#cat "$var_dir/$varfile" "$script" | ssh -i $PRIKEY $USER@$address "bash -s "
		execute_script "$var_dir/$varfile"
	done
}
help_func() {
	echo "This is the script responsible for executing the script on the remote hosts, these are the parameters"
	echo ""
	echo "-t		transfer credentials to the user directories"
	echo "-s		execute the setup scripts in each host"
	echo "-g		execute the grading scripts and print the output"
	echo "-c		the number of the server you want to setup"
	echo "-v		verbose, is still in implementation"
	echo "-f		file.sh to execute on a selected server"
	echo "-h		print the usage/help text, like this"
}
while getopts "tsf:ghvc:" opt
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
		c)
			let count=${OPTARG}
			let servers=$(ls -d environments/server_*/| wc -l)
			if (( count < 0 )) || (( count > servers ))
			then
				echo "The selected Server doesn't exist, please choose a server between 1 and $servers"
				exit 1
			fi
			CCOUNT=false
			;;
		v)
			DEBUG=true
			;;
		f)

			script=${OPTARG}
			execute_script "$script"
			FUNC_EXEC=false
			;;
		h)

			help_func
			;;
		*)
			help_func
			exit 1
			;;
	esac


done
while [[ -n ${!CURRENT_HOSTNAME} ]] && [[ $FUNC_EXEC == "true" ]]
do
#	echo "$CURRENT_HOSTNAME:${!CURRENT_HOSTNAME}"
#	echo "$CURRENT_ADDRESS:${!CURRENT_ADDRESS}"
#	echo "$CURRENT_HOST:${!CURRENT_HOST}"
	#transfer_credentials ${!CURRENT_ADDRESS}
	#setup_host $count ${!CURRENT_ADDRESS}
	$opt_func
	[[ $CCOUNT=="true" ]] && ((count++))
	CURRENT_HOSTNAME="HOSTNAME_$count"
	CURRENT_HOST="HOST_$count"
	CURRENT_ADDRESS="ADDRESS_$count"
done
