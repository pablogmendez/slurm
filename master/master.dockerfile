FROM centos:latest

WORKDIR /tmp

RUN yum install python-setuptools && easy_install supervisor

# Configure supervisor to start sshd
ADD config/supervisor /tmp/supervisor
RUN mkdir -p /etc/supervisor/conf.d && \
    cp supervisor/supervisord.conf /etc/supervisor/supervisord.conf && \
    cp supervisor/sshd.conf /etc/supervisor/conf.d/

ADD config/init.sh /root/

RUN touch /root/a.txt && chmod 777 /root/init.sh && /root/init.sh

CMD tail -f /root/a.txt