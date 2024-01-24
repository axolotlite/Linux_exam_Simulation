#!/bin/bash
#this is the script responsible for creating the custom repo and creating a custom httpd that uses port 82 instead of 80.
WORKDIR="/root/.workdir"
dnf config-manager --set-enabled crb
dnf install epel-release epel-next-release -y
dnf install yum-utils rpmrebuild createrepo httpd httpd-tools -y

#download httpd
systemctl enable --now httpd
#setting up apache server to serve the repo
firewall-cmd --add-service=http --permanent
firewall-cmd --reload

mkdir -p $WORKDIR
yumdownloader httpd --destdir=$WORKDIR
#create the custom repo and default repos
mkdir -p /var/www/html/custom/{Packages,repodata}
mkdir -p /var/www/html/BaseOS/
mkdir -p /var/www/html/AppStream/
mkdir /.cdrom
mount /dev/sr0 /.cdrom
mount --bind /.cdrom/BaseOS /var/www/html/BaseOS/
mount --bind /.cdrom/AppStream /var/www/html/AppStream/
#create a custom httpd package
rpmrebuild -s $WORKDIR/httpd_exam.spec $WORKDIR/httpd-*.rpm
patch $WORKDIR/httpd_exam.spec $WORKDIR/httpd_exam.spec.patch
rpmrebuild --change-spec-whole="cat $WORKDIR/httpd_exam.spec" -nb -d $WORKDIR -p $WORKDIR/httpd-*.rpm
cp $WORKDIR/x86_64/httpd_exam-*.rpm /var/www/html/custom/Packages/
rm -rf $WORKDIR $HOME/rpmbuild
#now we initialize our custom repo with the httpd_exam
createrepo /var/www/html/custom/
#ensure selinux permissions are set correctly, for some reason they sometimes break.

