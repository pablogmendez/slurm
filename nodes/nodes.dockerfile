FROM centos:latest

WORKDIR /tmp

# Configure proxy
#RUN export http_proxy="http://pgmendez:Octubre2017@10.1.1.88:3128" && \
#	export https_proxy="http://pgmendez:Octubre2017@10.1.1.88:3128" && \
#	echo "proxy=http://10.1.1.88:3128" >> /etc/yum.conf && \
#	echo "proxy_username=pgmendez" >> /etc/yum.conf && \
#	echo "proxy_password=Octubre2017" >> /etc/yum.conf && \
#	yum update -y &&

RUN yum install python-setuptools -y && easy_install pip && \
	pip install --proxy="$http_proxy" supervisor && \
	yum -y install openssh-server epel-release openssh-clients pwgen sshpass rpm-build readline-devel openssl pam-devel && \
	yum -y install lynx make gcc perl-YAML perl-CPAN-DistnameInfo perl-Test-Mock-LWP gcc-c++ cpan perl-Time-HiRes perl-Version-Requirements perl-CPAN

# Configure supervisor
ADD config/supervisor /tmp/supervisor
RUN mkdir -p /etc/supervisor/conf.d && \
    cp supervisor/supervisord.conf /etc/supervisor/supervisord.conf && \
    cp supervisor/sshd.conf /etc/supervisor/conf.d/ && \
    cp supervisor/munged.conf /etc/supervisor/conf.d/

# Configure ssh
ADD config/init.sh /root/
ADD config/init2.sh /root/
RUN chmod 775 /root/init.sh && chmod 775 /root/init2.sh && /root/init.sh
CMD /root/init2.sh