#!/bin/bash
#This script gets the environment variables from the problems and helps you set them.
#
PROBLEMS=()
DEF_HOST="(no host selected)"
HOST="(no host selected)"
HOST="environments/server_1/"
get_vars () {
	location="$1/$2"
	IFS=$'\n' vars=($(awk '/#-/{flag=!flag; next} flag' $location))
	DESC="$(awk '/DESC="/{flag=1;next} /"/ {flag=0} flag' $location)"
#	filename="$(awk -F/ '{print $NF}' <<< $1)"
#	filename="${filename%.*}.vars"
	filename="${2%.*}"
	var_count=$(ls $HOST/$1/$filename* 2> /dev/null| wc -l)
	echo $var_count
	filename="${2%.*}.vars.$var_count"
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
	OPTS="host add remove list archive restore clear quit"
	if [[ $SERVER_COUNT == 0 ]]
	then
		set_hosts
	else
		echo "There is already $SERVER_COUNT preset server directories, skipping directory creation."
	fi
	#echo "these are the variables and their defaults values"
	PS3="$HOST main> "
	select opt in $OPTS
	 do
	 	echo "you chose ($REPLY)$opt"
	 	case $opt in
			"host")
				PS3="$HOST host> "
				echo "$REPLY) set the current host for these problems"
				echo "There are currently $(get_hosts) hosts setup"
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
						*[0-9]*)
							echo "host $opt is now selected, please choose problems for this host"
							HOST="$opt"
							echo $HOST
							break
							;;
						*)
							echo "option $opt unavailable."
					esac
				done
				;;
	 		"add")
	 			echo "$REPLY) set variables to the practice environment"
				echo "you can exit by selecting q"
				PS3="$HOST add> "
				select dir in problems scripts
				do
					echo "you can exit by selecting q"
					[[ $REPLY == "q" ]] && break
					PS3="$HOST add $dir> "
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
				PS3="$HOST remove> "
	 			echo "$REPLY) remove a problem"
				echo "you can exit by selecting q"
				PS3="$HOST remove> "
				select dir in problems scripts
				do
					echo "you can exit by selecting q"
					[[ $REPLY == "q" ]] && break
					PS3="$HOST remove $dir> "
		 			select script in $(ls $HOST/$dir/)
		 			do
						[[ $REPLY == "q" ]] && break
		 				echo "$script has been deleted."
		 				rm "$HOST/$dir/$script"
						break
		 			done
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
				PS3="$HOST restore> "
				restore_exam
				;;
			"clear")
				echo "$REPLY) clear the already existing problems"
				clear_env
				HOST="(no host currently selected)"
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
	 PS3="$HOST main>"
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

if [[ $(ls -d environments/*/ 2> /dev/null) ]]
then
	select opt in $(ls environments/*/ -d 2> /dev/null)
	do
		case $opt in
			*[1-9]*)
				HOST="$opt"
				break
				;;
			'q')
				echo "exiting..."
				exit 0
				;;
			*)
				echo "$opt invalid option"
				;;
		esac
	done
fi
interactive
