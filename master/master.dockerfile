FROM centos:latest

WORKDIR /tmp

RUN export http_proxy="http://pgmendez:Octubre2017@10.1.1.88:3128" && \
	export https_proxy="http://pgmendez:Octubre2017@10.1.1.88:3128" && \
	echo "proxy=http://10.1.1.88:3128" >> /etc/yum.conf && \
	echo "proxy_username=pgmendez" >> /etc/yum.conf && \
	echo "proxy_password=Octubre2017" >> /etc/yum.conf && \
	yum update -y && \
	yum install python-setuptools -y && easy_install pip && \
	pip install --proxy="$http_proxy" supervisor

# Configure supervisor to start sshd
ADD config/supervisor /tmp/supervisor
RUN mkdir -p /etc/supervisor/conf.d && \
    cp supervisor/supervisord.conf /etc/supervisor/supervisord.conf && \
    cp supervisor/sshd.conf /etc/supervisor/conf.d/

# Configure ssh
ADD config/init.sh /root/
RUN chmod 777 /root/init.sh && /root/init.sh

RUN tail -f /dev/null