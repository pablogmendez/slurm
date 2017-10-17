#!/bin/bash

if [ ! -d /tmp/common/provisions/slurm/rpmbuild ]; then
	echo "Compilando slurm"
	chown root:toot /tmp/common/provisions/slurm/slurm-17.02.7.tar.bz2
	rpmbuild -ta /tmp/common/provisions/slurm/slurm-17.02.7.tar.bz2
	cp -R /root/rpmbuild/RPMS/x86_64/rpmbuild /tmp/common/provisions/slurm
fi
cd /tmp/common/provisions/slurm/rpmbuild/RPMS/x86_64
echo "Instalando slurm"
rpmbuild -ta slurm-17.02.7-1.el7.centos.x86_64.rpm slurm-contribs-17.02.7-1.el7.centos.x86_64.rpm slurm-devel-17.02.7-1.el7.centos.x86_64.rpm slurm-munge-17.02.7-1.el7.centos.x86_64.rpm slurm-openlava-17.02.7-1.el7.centos.x86_64.rpm slurm-pam_slurm-17.02.7-1.el7.centos.x86_64.rpm slurm-perlapi-17.02.7-1.el7.centos.x86_64.rpm slurm-plugins-17.02.7-1.el7.centos.x86_64.rpm slurm-slurmdbd-17.02.7-1.el7.centos.x86_64.rpm slurm-sql-17.02.7-1.el7.centos.x86_64.rpm slurm-torque-17.02.7-1.el7.centos.x86_64.rpm