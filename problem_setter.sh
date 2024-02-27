#!/bin/bash
#This script gets the environment variables from the problems and helps you set them.
#
PROBLEMS=()
HOST=""
get_vars () {
	IFS=$'\n' vars=($(awk '/#-/{flag=!flag; next} flag' $1))
	DESC="$(awk '/DESC="/{flag=1;next} /"/ {flag=0} flag' $1)"
	filename="$(awk -F/ '{print $NF}' <<< $1)"
	filename="${filename%.*}.vars"
	echo "#This is an automatically created file, modification may cause an error and are not persistent." > environments/$filename
	echo "$DESC"
	#echo "vars: ${vars[@]}"
	for var in ${vars[@]}
	do
#		echo "variable: $var"
		IFS='=$' read -r a b <<< "$var"
		b=${b#\$\{*=}
		b=${b%\}}
		echo "$a=$b"
		read -p "Do you want to modify $a variable(yes/no) ? " reply
		case $reply in 
			"y"|"yes"|"Y"|"YES")
				read -p "$a=" b
				;;
			"n"|"no"|"N"|"NO")
				;;
		esac
		echo "$a=$b" >> $HOST/$filename
		variables+=($a)
		values+=($b)
#		echo -e "a: $a \nb:$b"
	done
}
set_host() {
	echo "How many hosts will you need?"
	read -p "number of hosts: " host_count
	for itr in $(seq $host_count)
	do
		HOST="environments/server_$itr/"
		mkdir $HOST
		read -p "Hostname of host $itr: " HOSTNAME
		read -p "address of host $itr: " ADDRESS
		echo '#new host' >>environments/hosts.env
		echo "HOSTNAME_$itr=\"$HOSTNAME\"" >> environments/hosts.env
		echo "ADDRESS_$itr=\"$ADDRESS\"" >> environments/hosts.env
		echo "HOST_$itr=\"\$ADDRESS_$itr \$HOSTNAME_$itr\"" >> environments/hosts.env
	done
}
SERVER_COUNT="$(ls -d environments/server_* 2> /dev/null| wc -l)"
if [[ $SERVER_COUNT == 0 ]]
then
	set_host
else
	echo "There is already $SERVER_COUNT preset server directories, skipping directory creation."
fi
#echo "these are the variables and their defaults values"
 OPTS="set add remove list clear quit"
 select opt in $OPTS
 do
 	echo "you chose ($REPLY)$opt"
 	case $opt in
		"set")
			echo "1)set the current host for these problems"
			ls -d environments/server_* &> /dev/null || set_host 
			select host in $(ls environments/*/ -d)
			do
				echo "host $host is now selected, please choose problems for this host"
				HOST="$host"
				break
			done
			;;
 		"add")
 			echo "2)add problems to the practice text"
 			select problem in $(ls problems/)
 			do
 				echo "$problem is now selected"
 				get_vars problems/$problem
 				break
 			done
 			;;
 		"remove")
 			echo "3)remove a problem"
			select problem in $(ls $HOST)
 			do
 				rm "$HOST/$problem"
 				break
 			done
 			;;
 		"list")
 			echo "4) show selected hosts problem variables"
			if [[ -z $HOST ]]
			then
				echo "Host not selected, please set a host before trying again"
			elif [[ $(ls $HOST) == "" ]]
			then
				echo "no problems selected for host $HOST, please add some problems."
			else
				ls $HOST
			fi
 			;;
		"clear")
			echo "5) clear the already existing problems"
			rm -rf environments/server_*
			echo "" > environments/hosts.env
			echo "cleared..."
			;;
 		"help")
 			;;
 		"quit")
 			echo "exiting..."
 			exit 0
 			;;
 	esac
 done
