FROM ubuntu:22.04

RUN apt update -y
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive 

RUN apt install -y \
    autoconf \
    gcc \
    libc6 \
    make \
    wget \
    unzip \
    apache2 \
    apache2-utils \
    php \
    libapache2-mod-php \
    libgd-dev \
    libssl-dev \
    libmcrypt-dev \
    bc \
    gawk \
    dc \
    build-essential \
    snmp \
    libnet-snmp-perl \
    gettext \
    fping \
    iputils-ping \
    qstat \
    dnsutils \
    smbclient

# Construcción de Nagios Core
COPY nagios-4.4.9 /nagios-4.4.9
WORKDIR /nagios-4.4.9
RUN ./configure --with-httpd-conf=/etc/apache2/sites-enabled && \
    make all && \
    make install-groups-users && \
    usermod -aG nagios www-data && \
    make install && \
    make install-init && \
    make install-daemoninit && \
    make install-commandmode && \
    make install-config && \
    make install-webconf && \
    a2enmod rewrite cgi

# Construcción de Plugins de Nagios
COPY nagios-plugins-2.4.2 /nagios-plugins-2.4.2
WORKDIR /nagios-plugins-2.4.2
RUN autoconf && \
    ./configure --with-nagios-user=nagios --with-nagios-group=nagios && \
    make && \
    make install

# Construir e Instalar Plugins NRPE
COPY nrpe-4.1.0 /nrpe-4.1.0
WORKDIR /nrpe-4.1.0
RUN ./configure && \
    make all && \
    make install-plugin

WORKDIR /root

# Copia las credenciales de autenticación básica de Nagios establecidas en el archivo de entorno.
COPY .env /usr/local/nagios/etc/

# Agregar el script de inicio de Nagios y Apache.
ADD start.sh /
RUN chmod +x /start.sh

CMD [ "/start.sh" ]
