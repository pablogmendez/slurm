###############################################################
##                           SSH                             ##
###############################################################

## Install the openssh-server and epel-release
#rm -f /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_rsa_key
#ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_ecdsa_key
#ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key 
ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config
sed -i "s/UsePAM.*/UsePAM yes/g" /etc/ssh/sshd_config
ssh-keygen -A

## Create Set Root Password Script. Name it as set_root_pw.sh. Save it in a folder
ROOT_PASS="Alfa1234"
PASS=${ROOT_PASS:-$(pwgen -s 12 1)}
_word=$( [ ${ROOT_PASS} ] && echo "preset" || echo "random" )
echo "=> Setting a ${_word} password to the root user"
echo "root:$PASS" | chpasswd
echo "=> Done!"
touch /.root_pw_set
echo "========================================================================"
echo "You can now connect to this CentOS container via SSH using:"
echo ""
echo "    ssh -p  root@"
echo "and enter the root password '$PASS' when prompted"
echo ""
echo "Please remember to change the above password as soon as possible!"
echo "========================================================================"

## Create run.sh file with following content and save it in same folder as the above
## set_root_pw.sh

if [ "${AUTHORIZED_KEYS}" != "**None**" ]; then
    echo "=> Found authorized keys"
    mkdir -p /root/.ssh
    chmod 700 /root/.ssh
    touch /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
    IFS='\n'
    arr=$(echo ${AUTHORIZED_KEYS} | tr "," "\n")
    for x in $arr
    do
        x=$(echo $x |sed -e 's/^ *//' -e 's/ *$//')
        cat /root/.ssh/authorized_keys | grep "$x" >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "=> Adding public key to /root/.ssh/authorized_keys: $x"
            echo "$x" >> /root/.ssh/authorized_keys
        fi
    done
fi

if [ ! -f /.root_pw_set ]; then
    /set_root_pw.sh
fi

# Key exchange with work nodes
# Generate public-private keys
# ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
sshpass -p $PASS ssh-copy-id node01
# while read -r node; do
#     echo "Execute key exchange within Master and $node"
#     sshpass -p $PASS ssh-copy-id $node
#     [ $? -eq 0 ] || exit 1
#     echo "Done"
# done < /root/work_node_list.dat

###############################################################
##                          Maria DB                         ##
###############################################################

# Install Maria DB
#yum install mariadb-server mariadb-devel -y

###############################################################
##                       Global Users                        ##
###############################################################
# Create global users
# export MUNGEUSER=991
# groupadd -g $MUNGEUSER munge
# useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER -g munge  -s /bin/bash munge
# export SLURMUSER=992
# groupadd -g $SLURMUSER slurm
# useradd  -m -c "SLURM workload manager" -d /var/lib/slurm -u $SLURMUSER -g slurm  -s /bin/bash slurm

###############################################################
##                          Munge                            ##
###############################################################
# Install Munge
# yum install epel-release
# yum install munge munge-libs munge-devel -y
# echo "In9LBtuTZrugWYyIeN6s1bgdg0c3yqfd" >/etc/munge/munge.key
# chown munge: /etc/munge/munge.key
# chmod 400 /etc/munge/munge.key

# cd /tmp/slurm
# chown root:toot slurm-17.02.7.tar.bz2
# rpmbuild -ta slurm-17.02.7.tar.bz2
# cd /root/rpmbuild/RPMS/x86_64
# rpmbuild -ta slurm-17.02.7-1.el7.centos.x86_64.rpm slurm-contribs-17.02.7-1.el7.centos.x86_64.rpm slurm-devel-17.02.7-1.el7.centos.x86_64.rpm slurm-munge-17.02.7-1.el7.centos.x86_64.rpm slurm-openlava-17.02.7-1.el7.centos.x86_64.rpm slurm-pam_slurm-17.02.7-1.el7.centos.x86_64.rpm slurm-perlapi-17.02.7-1.el7.centos.x86_64.rpm slurm-plugins-17.02.7-1.el7.centos.x86_64.rpm slurm-slurmdbd-17.02.7-1.el7.centos.x86_64.rpm slurm-sql-17.02.7-1.el7.centos.x86_64.rpm slurm-torque-17.02.7-1.el7.centos.x86_64.rpm

# while read -r line; do
#     scp /root/rpmbuild/RPMS/x86_64/* $line:/tmp
# done < /root/config/work_node_list.dat

# Copy the Munge key in every node
#while read -r node; do
#    sshpass -p $PASS scp /etc/munge/munge.key $node:/etc/munge
#    sshpass -p $PASS ssh "chown -R munge: /etc/munge/ /var/log/munge/ && chmod 0700 /etc/munge/ /var/log/munge/"
#done < /root/work_node_list.dat
