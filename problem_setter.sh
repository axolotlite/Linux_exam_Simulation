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
	HOST="environments/server_$1/"
	mkdir $HOST
	read -p "Hostname of host $1: " HOSTNAME
	read -p "address of host $1: " ADDRESS
	echo '#new host' >>environments/hosts.env
	echo "HOSTNAME_$1=\"$HOSTNAME\"" >> environments/hosts.env
	echo "ADDRESS_$1=\"$ADDRESS\"" >> environments/hosts.env
	echo "HOST_$1=\"\$ADDRESS_$1 \$HOSTNAME_$1\"" >> environments/hosts.env
}
echo "How many hosts will you need?"
read -p "number of hosts: " host_count
for host in $(seq $host_count)
do
	set_host $host
done
#echo "these are the variables and their defaults values"
 OPTS="set add remove list quit"
 select opt in $OPTS
 do
 	echo "you chose ($REPLY)$opt"
 	case $opt in
		"set")
			echo "1)set the current host for these problems"
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
 				PROBLEMS+=($problem)
 				break
 			done
 			;;
 		"remove")
 			echo "3)remove a problem"
 			select problem in ${PROBLEMS[@]}
 			do
				echo "removing problem $problem from $host"
 				rm "$HOST/${problem%.*}.vars"
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
 		"help")
 			;;
 		"quit")
 			echo "exiting..."
 			exit 0
 			;;
 	esac
 done
