#!/bin/bash
DESC="
This scripts sets up a custom package and is in need of generalization and an external repo
"
#-
WORKDIR=${WORKDIR:="/root/.workdir"}
PACKAGE=${PACKAGE:="httpd"}
CUST_PACKAGE=${CUST_PACKAGE:="httpd_exam"}
CUST_SPEC=${CUST_SPEC:="htpd_exam.spec"}
CUST_PATCH=${CUST_PATCH:="httpd_exam.spec.patch"}
REPO_DIR=${REPO_DIR:="/var/www/html/custom/Packages"}
#-
dnf config-manager --set-enabled crb
dnf install epel-release epel-next-release -y
dnf install yum-utils rpmrebuild -y
#make a workdir
mkdir -p $WORKDIR
yumdownloader $PACKAGE --destdir=$WORKDIR

rpmrebuild -s $WORKDIR/$CUST_SPEC $WORKDIR/$PACKAGE-*.rpm
patch $WORKDIR/$CUST_SPEC $WORKDIR/$CUST_PATCH
rpmrebuild --change-spec-whole="cat $WORKDIR/$CUSTOM_SPEC" -nb -d $WORKDIR -p $WORKDIR/$PACKAGE-*.rpm
#ensure that the repo exists
mkdir -p $REPO_DIR
cp $WORKDIR/x86_64/$CUSTOM_PACKAGE-*.rpm $REPO_DIR
