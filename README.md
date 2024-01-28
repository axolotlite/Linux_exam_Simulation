# Redhat exam simulation
This is a collection of scripts that simulates the Redhat certification exam.
It's written in bash, uses ssh to go into 3 VM hosts to setup the environment, and problems. Once you finish the exam, it will run a collection of user defined scripts to check the users answers then grade it.
## How to use:
first of all, these scripts were tested on:
- CentOS 9
First download [centos 9 iso](https://www.centos.org/download/)
During the Installation process on all the virtual machines, setup the root user and password.
once you've finished installing centos 9 on the 3 virtual machines, go to `environment/hosts.env` 
set the following variables:
```
CLASSROOM_ADDRESS="VM 1 ip address"
LAB_A_ADDRESS="VM 2 ip address"
LAB_B_ADDRESS="VM 3 ip address"
```
next, you will have to generate the ssh key, cd to `credentials` then run the `generate_keys.sh` script which will create two files inside the directory
```
credentials/utility
credentials/utility.pub
```
next you can setup the labs by running:
`./setup.sh`

The lab is now setup, ssh into the Lab vms and do your mock exam.
#### Grading
after you're done with the exam, go back to your host and run:
`./grade.sh exams/redhat.sh`
____

## Directories
These are the directories in the project and their relevant uses
##### exam
a script file containing the problem file names that should be executed / checked on their respective hosts.
##### credentials
contains keys, and any other credential data such as certificates
##### environments
environmental files that could be fed to scripts
##### patches
SPEC patch files, if you want to generate custom packages during yum repo initialization
##### problems
scripts that check for problem solution, each script should contain the problem definition and relevant variables. (may move the variables to the environments file)
##### scripts
The initialization scripts for the lab VMs.
