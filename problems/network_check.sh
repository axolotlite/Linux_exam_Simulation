#!/binb/bash
#relevant answers
HOSTNAME=""
ADDRESS=""
MASK=""
GATEWAY=""
NAMESERVER=""
#first, check the hostname
hostname=$(cat /etc/hostname)
#second, the ip address and mask
address=$(ip -o -4 addr show $(ip route get 1 | awk '{print $5; exit}') | awk '{print $4}')
#third, the gateway
gateway=$(ip -o -4 route show default | awk '{print $3}')
#finally the nameserver
nameserver=$(awk '/nameserver/ {print $2}' /etc/resolv.conf)

#compare everything
#hostname
if [[ hostname == HOSTNAME ]] then;
	echo "hostname correct"
else
	echo "hostname mismatch
fi
#address and netmask
if [[ address == ADDRESS ]] then;
	echo "address and netmask correct
else
	echo "address and network are wrong"
fi
#gateway
if [[ gateway == GATEWAY ]] then;
	echo "correct gateway, but you already knew that when you pinged it"
else
	echo "incorrect gateway"
fi
#nameserver
if [[ nameserver == NAMESERVER ]] then;
	echo "nameserver resolution works"
else
	echo "incorrect nameserver address"
fi
