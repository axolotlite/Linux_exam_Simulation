#!/bin/bash
DESC="
check the umask of user
USER: user to check the stuff for
"
#-
USER=${USER:="natasha"}
#-
[[ $(sudo -u $USER -i umask) == 0277 ]] && echo umask set correctly || umask mistake

#default password expiry date should be set to 20 days
MAXDAYS=99999
[[ $(awk '/PASS_MAX_DAYS.*[0-9]/ {print $NF}' /etc/login.defs ) == $MAXDAYS ]] && echo "expiration date set correctly" || echo "expiration date set wrong"
#check if sudoers has a group with no passwd to invoke sudo
[[ $(grep "^%admin.*NOPASSWD" /etc/sudoers) ]] && echo "sudoers set correctly" || echo "sudoers set falsely"
#check for special welcome message
[[ $(grep "Welcome to Advantage Pro" /home/$USER/.bash_profile || grep "Welcome to Advantage Pro" /home/$USER/.bashrc) ]] && echo string found
