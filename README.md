#Esta Instalación esta basada en una EC2 de AWS con sistema amazon linux
1. Nos conectamos a la maquina y comenzamos a ejecutar los siguientes comandos:

#actualziamos el sistema
sudo yum update -y

#Instalamos Docker y dejamos el servicio corriendo persistente
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable Docker

#Le damos permisos al usuario ec2-user (que es el por defecto al conectarnos ala maquina) 
sudo usermod -a -G docker ec2-user
#salir para que tome los cambios en la cuenta
exit

#Volvemos a conectarnos a la maquina y descargamos git
sudo yum install git -y

#Clonamos el repositorio

git clone https://github.com/anivc/prueba2

#Navega al Directorio del Repositorio

cd prueba2/

#Crea un directorio donde se copiarán los archivos necesarios:

sudo mkdir /opt/nagios-core-docker

sudo cd /opt/nagios-core-docker/

#Descarga los archivos necesarios:

wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.9.tar.gz

tar xzf nagios-4.4.9.tar.gz

wget https://github.com/nagios-plugins/nagios-plugins/releases/download/release-2.4.2/nagios-plugins-2.4.2.tar.gz

tar xzf nagios-plugins-2.4.2.tar.gz

wget https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-4.1.0/nrpe-4.1.0.tar.gz

tar xzf nrpe-4.1.0.tar.gz

#Se recomienda verificar la integridad de los archivos descargados mediante la comprobación de su suma de comprobación (checksum).

2. Configuración de las credenciales de autenticación
Define las credenciales de autenticación básicas de Nagios en el archivo .env. Puedes modificar este archivo según las credenciales de autenticación que necesites utilizar.

NAGIOSADMIN_USER=nagiosadmin NAGIOSADMIN_PASSWORD=password

3. Compilación de la imagen Docker
#Construye la imagen Docker utilizando el Dockerfile proporcionado.

docker build -t nagios-core-4.4.9 .

4. Ejecución del contenedor Docker
#Crea y ejecuta el contenedor de Nagios-Core utilizando el siguiente comando:

docker run --name nagios-core-4.4.9 -dp 80:80 nagios-core-4.4.9

**Si necesitas anular las credenciales definidas en el archivo .env, usa el siguiente comando:

docker run -e NAGIOSADMIN_USER_OVERRIDE=monadmin -e NAGIOSADMIN_PASSWORD_OVERRIDE=password --name nagios-core-4.4.9 -dp 80:80 nagios-core:4.4.9

5. Acceso a la interfaz web principal de Nagios
#Verifica si todo está bien accediendo a la interfaz web de Nagios Core en:

http://docker-host-IP-or-hostname/nagios/
