FROM centos:latest

WORKDIR /tmp

# Configure proxy
#RUN export http_proxy="http://pgmendez:Octubre2017@10.1.1.88:3128" && \
#	export https_proxy="http://pgmendez:Octubre2017@10.1.1.88:3128" && \
#	echo "proxy=http://10.1.1.88:3128" >> /etc/yum.conf && \
#	echo "proxy_username=pgmendez" >> /etc/yum.conf && \
#	echo "proxy_password=Octubre2017" >> /etc/yum.conf && \
#	yum update -y &&

# Install common tools and configure ssh
RUN yum install python-setuptools -y && easy_install pip && \
	pip install --proxy="$http_proxy" supervisor && \
	yum -y install openssh-server epel-release openssh-clients \
	pwgen sshpass rpm-build readline-devel openssl pam-devel \
	lynx make gcc perl-YAML perl-CPAN-DistnameInfo perl-Test-Mock-LWP \
	gcc-c++ cpan perl-Time-HiRes perl-Version-Requirements perl-CPAN

# Install and configure mariadb
RUN yum install mariadb-server mariadb-devel -y && \
	chmod 777 /tmp/common/scripts/configure_mariadb.sh && \
	/tmp/common/scripts/configure_mariadb.sh

# Install Munge
RUN yum install epel-release munge munge-libs munge-devel -y && \
	chmod 777 /tmp/common/scripts/configure_munge.sh && \
	/tmp/common/scripts/configure_munge.sh

# Configure supervisor
ADD config/slurm /tmp/slurm
ADD config/supervisor /tmp/supervisor
RUN mkdir -p /etc/supervisor/conf.d && \
    cp supervisor/supervisord.conf /etc/supervisor/supervisord.conf && \
    cp supervisor/sshd.conf /etc/supervisor/conf.d/ && \
    cp supervisor/munged.conf /etc/supervisor/conf.d/

# Install slurm
RUN /tmp/common/scripts/install_slurm.sh

# Configure ssh
RUN chmod 775 /tmp/common/scripts/init.sh
CMD /tmp/common/scripts/init.sh
