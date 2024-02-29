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
get_hosts(){
	count=$(ls -d environments/server_* 2> /dev/null| wc -l)
	echo $count
}
clear_env() {	
	reply=$1
	[[ -n $reply ]] || read -p "Are you sure you want to delete the current environment configuration? (yes/no): " reply
	case $reply in 
		"y"|"yes"|"Y"|"YES")
			rm -rf environments/server_*
			echo "" > environments/hosts.env
			echo "Environment configurations cleared..."
			;;
		"n"|"no"|"N"|"NO")
			;;
	esac
}
archive_exam(){
	read -p "archive name: " name
	tar cf "archive/$name-$(date "+%Y-%m-%d")-archive.tar" environments/hosts.env environments/server_*
}
restore_exam(){
	select opt in $(ls archive)
	do
		tar xf archive/$opt
		break
	done
}
interactive () {
	SERVER_COUNT=$(get_hosts)
	OPTS="set add remove list archive restore clear quit"
	if [[ $SERVER_COUNT == 0 ]]
	then
		set_hosts
	else
		echo "There is already $SERVER_COUNT preset server directories, skipping directory creation."
	fi
	#echo "these are the variables and their defaults values"
	select opt in $OPTS
	 do
	 	echo "you chose ($REPLY)$opt"
	 	case $opt in
			"set")
				echo "$REPLY) set the current host for these problems"
				echo "There are currently $(get_hosts) hosts setup"
#				(( $(get_hosts) )) || set_host 1
				select opt in $(ls environments/*/ -d 2> /dev/null) "add host" "quit"
				do
					case $opt in
						"add host")
							let count=$(get_hosts)+1
							HOST=$(set_host $count)
							break
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
	 			echo "$REPLY) set variables to the practice environment"
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
	 			echo "$REPLY) remove a problem"
				select problem in $(ls $HOST)
	 			do
	 				rm "$HOST/$problem"
	 				break
	 			done
	 			;;
	 		"list")
	 			echo "$REPLY) show selected hosts problem variables"
					ls $HOST/{problems,scripts}
	 			;;
			"archive")
				echo "$REPLY) archive the current exam with all its parameters and variables"
				archive_exam
				;;
			"restore")
				echo "$REPLY) restores an exam with all its data"
				let count=$(get_hosts)
				if (( count )) 
				then
					echo "There is already $count server directories set."
					read -p "Do you want to archive them(yes/no)? >> " reply
					case $reply in 
						"y"|"yes"|"Y"|"YES")
							archive_exam
							echo "exam archived, deleting current configs..."
							clear_env $reply
							;;
						"n"|"no"|"N"|"NO")
							clear_env
							;;
					esac
				fi
				restore_exam
				;;
			"clear")
				echo "$REPLY) clear the already existing problems"
				clear_env
				;;
	 		"help")
	 			;;
	 		"quit")
	 			echo "exiting..."
	 			exit 0
	 			;;
			*)
				echo "$REPLY option unavailable"
				;;
	 	esac
	 done
 }
#short_options="s:a:r:m:l:c:h"
#long_options=("select:" "add:" "remove:" "modify:" "list:" "clear:" "help:")
#
# while getopts "$short_options" opt;
# do
#	 case $opt in
#		 s)
#			 let count=$get_hosts+1
#			 HOST="environments/server_$count/"
#			 mkdir -p $HOST/{scripts,problems}
#			 ;;
#		 a)
#			 echo "a"
#			 ;;
#		 r)
#			 echo "r"
#			 ;;
#		 m)
#			 echo "m"
#			 ;;
#		 l)
#			 echo "l"
#			 ;;
#		 c)
#			 echo "c"
#			 ;;
#		 h)
#			 echo "h"
#			 ;;
#	esac
# done
interactive
