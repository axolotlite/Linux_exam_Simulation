#!/bin/bash
#This script gets the environment variables from the problems and helps you set them.
#
PROBLEMS=()
HOST=""
get_vars () {
	location="$1/$2"
	IFS=$'\n' vars=($(awk '/#-/{flag=!flag; next} flag' $location))
	DESC="$(awk '/DESC="/{flag=1;next} /"/ {flag=0} flag' $location)"
#	filename="$(awk -F/ '{print $NF}' <<< $1)"
#	filename="${filename%.*}.vars"
	filename="${2%.*}.vars"
	echo "#This is an automatically created file, modification may cause an error and are not persistent." > $HOST/$1/$filename
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
		echo "$a=$b" >> $HOST/$1/$filename
		variables+=($a)
		values+=($b)
#		echo -e "a: $a \nb:$b"
	done
}
set_host() {
	itr="$1"
	HOST="environments/server_$itr/"
	mkdir -p $HOST/{scripts,problems}
	read -p "Hostname of host $itr: " HOSTNAME
	read -p "address of host $itr: " ADDRESS
	echo '#new host' >> environments/hosts.env
	echo "HOSTNAME_$itr=\"$HOSTNAME\"" >> environments/hosts.env
	echo "ADDRESS_$itr=\"$ADDRESS\"" >> environments/hosts.env
	echo "HOST_$itr=\"\$ADDRESS_$itr \$HOSTNAME_$itr\"" >> environments/hosts.env
	echo $HOST
}
set_hosts() {
	echo "How many hosts will you need?"
	read -p "number of hosts: " host_count
	for itr in $(seq $host_count)
	do
		set_host $itr
	done
}
SERVER_COUNT="$(ls -d environments/server_* 2> /dev/null| wc -l)"
if [[ $SERVER_COUNT == 0 ]]
then
	set_hosts
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
			ls -d environments/server_* &> /dev/null || set_host 1
			select opt in $(ls environments/*/ -d) "add host" "quit"
			do
				case $opt in
					"add host")
						let count=$(ls environments/*/ -d | wc -l)+1
						HOST=$(set_host $count)
						;;
					"quit")
						break
						;;
					*)
						echo "host $opt is now selected, please choose problems for this host"
						HOST="$opt"
						break
						;;
				esac
			done
			;;
 		"add")
 			echo "2)set variables to the practice environment"
			select dir in problems scripts
			do
				echo "you can exit by selecting q"
	 			select script in $(ls $dir/)
	 			do
					[[ $REPLY == "q" ]] && break
	 				echo "$script is now selected"
	 				get_vars $dir $script
	 			done
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
				ls $HOST/{problems,scripts}
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
