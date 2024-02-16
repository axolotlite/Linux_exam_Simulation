#!/binb/bash
#relevant answers
DESC="
This checks the network configuration set by the user
HOSTNAME: the hostname the user sets
ADDRESS: the static address the user sets
MASK: the mask the user sets
GATEWAY: the gateway the user sets
NAMESERVER: not sure yet
"
#-
HOSTNAME=${HOSTNAME:="lab"}
ADDRESS=${ADDRESS:="10.10.10.150"}
MASK=${MASK:="/24"}
GATEWAY=${GATEWAY:="10.10.10.1"}
NAMESERVER=${NAMESERVER:="10.10.10.150"}
#-
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
if [[ $hostname == $HOSTNAME ]] then;
	echo "hostname correct"
else
	echo "hostname mismatch"
fi
#address and netmask
if [[ $address == "$ADDRESS/$MASK" ]] then;
	echo "address and netmask correct"
else
	echo "address and network are wrong"
fi
#gateway
if [[ $gateway == $GATEWAY ]] then;
	echo "correct gateway, but you already knew that when you pinged it"
else
	echo "incorrect gateway"
fi
#nameserver
if [[ $nameserver == $NAMESERVER ]] then;
	echo "nameserver resolution works"
else
	echo "incorrect nameserver address"
fi
