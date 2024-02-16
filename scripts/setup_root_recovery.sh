#!/bin/bash
#this script will create a random password for root, in order for the user to attempt recovery
#it expects to be executed by ssh as the root user.
#
passwd -d root
passwd -l root

