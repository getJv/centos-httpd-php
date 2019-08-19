FROM centos:7.6.1810

MAINTAINER Jhonatan Morais <jhonatanvinicius@gmail.com>

# Utilitários
RUN yum install -y nano wget unzip git && \
# Instalação do httpd: https://github.com/CentOS/CentOS-Dockerfiles/tree/master/httpd/centos7
	yum -y --setopt=tsflags=nodocs update && \
    yum -y --setopt=tsflags=nodocs install httpd && \
	systemctl enable httpd.service && \
	touch /var/www/html/info.php && \
	echo "<?php phpinfo(); ?>" >> /var/www/html/info.php && \
#OCI + PHP7.2 Guide: 	http://bit.ly/2wYPIah
# Instalacao do PHP e do seus repositorios 
	yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
	yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
	yum install -y --setopt=tsflags=nodocs yum-utils && \
	yum-config-manager --enable remi-php72 && \
	yum install -y --setopt=tsflags=nodocs --skip-broken  php php-pecl-mcrypt php-cli php-gd php-curl php-mysqlnd php-ldap php-zip php-fileinfo php-xml php-intl php-mbstring php-opcache php-process systemtap-sdt-devel php-pear php-json php-devel php-common php-bcmath php-pdo php-pgsql php-oci8 && \

# Oracle Client: http://bit.ly/2INtGwF | 
ADD oracle-instantclient18.5-basic-18.5.0.0.0-3.x86_64.rpm /home/oracle-instantclient18.5-basic-18.5.0.0.0-3.x86_64.rpm
ADD oracle-instantclient18.5-devel-18.5.0.0.0-3.x86_64.rpm /home/oracle-instantclient18.5-devel-18.5.0.0.0-3.x86_64.rpm
RUN	yum install -y /home/oracle-instantclient18.5-basic-18.5.0.0.0-3.x86_64.rpm /home/oracle-instantclient18.5-devel-18.5.0.0.0-3.x86_64.rpm && \
	sh -c "echo /usr/lib/oracle/18.5/client64/lib > /etc/ld.so.conf.d/oracle-instantclient.conf" && \
	ldconfig && \
# Laravel Instalação e configuração
	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
	php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
	composer global require laravel/installer && \
	echo "alias laravel='~/.composer/vendor/bin/laravel'" >> ~/.bashrc && \
	alias laravel='~/.composer/vendor/bin/laravel' && \
	sed -i 's+/var/www/html+/var/www/html/${HTTPD_DOCUMENT_ROOT_CONTEXT}+g' /etc/httpd/conf/httpd.conf && \
	sed -i 's+AllowOverride None+AllowOverride ${HTTPD_ALLOW_OVER_RIDE_OPTION} \n SetEnv APPLICATION_ENV ${HTTPD_APPLICATION_ENV_OPTION} \n SetEnv ZF2_PATH ${HTTPD_ZF2_PATH}+g' /etc/httpd/conf/httpd.conf && \
	echo "LoadModule rewrite_module modules/mod_rewrite.so" >> /etc/httpd/conf.modules.d/00-base.conf

# Script para evitar complemas de reinicialização no container 
ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh && \
	yum clean all

WORKDIR /var/www/html/

EXPOSE 80

CMD ["/run-httpd.sh"]



