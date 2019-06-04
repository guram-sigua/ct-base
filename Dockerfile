FROM amazonlinux:2
CMD ["/usr/bin/supervisord"]
EXPOSE 9001

ENV JAVA_HOME /usr/java/latest

WORKDIR /tmp

RUN yum update -y
RUN yum install -y epel-release deltarpm
RUN yum install -y python-pip \
                   python-devel \
                   gcc \
                   wget \
                   git \
                   tar
				   
RUN pip install supervisor \
                requests==2.5.3 \
                awscli \
                boto3
				
RUN yum install -y  wget java-1.8.0-openjdk java-1.8.0-openjdk-devel

RUN curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo && \
    yum install -y sbt
	
COPY conf/supervisord.conf /etc/supervisord.conf


