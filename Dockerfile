FROM amazonlinux:2
CMD ["/usr/bin/supervisord"]
EXPOSE 222 9001

ENV JAVA_HOME /usr/java/latest

WORKDIR /tmp

RUN yum update -y
RUN yum install -y epel-release deltarpm
RUN yum install -y python-pip \
                   python-devel \
                   gcc \
                   wget \
                   git \
                   tar \
                   nano \
		   openssh-server \
                   openssh-clients
				   
RUN pip install supervisor \
                requests==2.5.3 \
                awscli \
                boto3
				
RUN echo 'root:ContaineR' | chpasswd && \
    rm -f /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && \
    sed -i "s/UsePAM.*/UsePAM yes/g" /etc/ssh/sshd_config
				
RUN yum install -y  wget java-1.8.0-openjdk java-1.8.0-openjdk-devel

RUN curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo && \
    yum install -y sbt
	
COPY conf/supervisord.conf /etc/supervisord.conf


