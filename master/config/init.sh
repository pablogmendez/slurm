## 
## Install the openssh-server and epel-release
##

yum -y install openssh-server epel-release openssh-clients
yum -y install pwgen
rm -f /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_rsa_key
ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_ecdsa_key
ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key 
sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config
sed -i "s/UsePAM.*/UsePAM yes/g" /etc/ssh/sshd_config
ssh-keygen -A

##
## Create Set Root Password Script. Name it as set_root_pw.sh. Save it in a folder
##

#!/bin/bash
if [ -f /.root_pw_set ]; then
    echo "Root password already set!"
    exit 0
fi

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

##
## Create run.sh file with following content and save it in same folder as the above
## set_root_pw.sh
##

#!/bin/bash

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
# Start supervisor
mkdir -p /var/log/supervisor
supervisord -c /etc/supervisor/supervisord.conf
#exec /usr/sbin/sshd -D