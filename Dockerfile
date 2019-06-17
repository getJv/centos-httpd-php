FROM centos:7.6.1810

MAINTAINER Jhonatan Morais <jhonatanvinicius@gmail.com>

# Instalação do httpd: https://github.com/CentOS/CentOS-Dockerfiles/tree/master/httpd/centos7
RUN yum -y --setopt=tsflags=nodocs update && \
    yum -y --setopt=tsflags=nodocs install httpd
    

# Script para evitar complemas de reinicialização no container
ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

#OCI + PHP7.2 Guide: 	http://bit.ly/2wYPIah
# Instalacao do PHP e do seus repositorios 
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm && \
	yum install -y http://rpms.remirepo.net/enterprise/remi-release-6.rpm && \
	yum install -y yum-utils && \
	yum-config-manager --enable remi-php72 && \
	yum install -y --skip-broken  php php-pecl-mcrypt php-cli php-gd php-curl php-mysqlnd php-ldap php-zip php-fileinfo php-xml php-intl php-mbstring php-opcache php-process systemtap-sdt-devel php-pear php-json php-devel php-common php-bcmath php-pdo && \
	yum install -y php-oci8

# Oracle Client: http://bit.ly/2INtGwF | 
ADD oracle-instantclient18.5-basic-18.5.0.0.0-3.x86_64.rpm /home/oracle-instantclient18.5-basic-18.5.0.0.0-3.x86_64.rpm
ADD oracle-instantclient18.5-devel-18.5.0.0.0-3.x86_64.rpm /home/oracle-instantclient18.5-devel-18.5.0.0.0-3.x86_64.rpm
RUN	yum install -y /home/oracle-instantclient18.5-basic-18.5.0.0.0-3.x86_64.rpm /home/oracle-instantclient18.5-devel-18.5.0.0.0-3.x86_64.rpm

RUN	sh -c "echo /usr/lib/oracle/18.5/client64/lib > /etc/ld.so.conf.d/oracle-instantclient.conf"
RUN ldconfig	

RUN yum clean all

EXPOSE 80

CMD ["/run-httpd.sh"]



