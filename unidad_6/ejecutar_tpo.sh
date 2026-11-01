#!/bin/bash
# ==============================================================================
# UNIDAD 6 - DEMOSTRACION COMPLETA DE SEGURIDAD EN RED HAT (ejecutar_tpo.sh)
# Reune en un unico script las 4 capas de seguridad:
#   1) Red y Firewall entre servidores (ping, ssh y firewall-cmd en servera y serverb)
#   2) Creacion del usuario 'auditor' y contrasena con Hash + Salt en /etc/shadow
#   3) Control de Acceso con ACL (setfacl / getfacl) sobre un archivo confidencial
#   4) Comprobador de Integridad con Hash SHA-256 (sha256sum -c) ante un virus
# ==============================================================================

PUERTO=8080

echo "========================================================================"
echo " 1. CONECTIVIDAD Y FIREWALL ENTRE SERVIDORES ('servera' Y 'serverb')"
echo "========================================================================"
# 'ping -c 2' envia 2 paquetes para comprobar que ambos servidores responden en la red
echo "-> Probando conexion de red con servera y serverb:"
ping -c 2 servera
echo ""
ping -c 2 serverb
echo ""

# Nos conectamos por SSH a 'servera' y cerramos el puerto 8080/tcp en su Firewall
echo "-> [servera]: Bloqueando el puerto $PUERTO/tcp en el Firewall..."
ssh student@servera "echo student | sudo -S firewall-cmd --remove-port=${PUERTO}/tcp >/dev/null 2>&1; echo student | sudo -S firewall-cmd --list-ports 2>/dev/null"

# Nos conectamos por SSH a 'serverb', abrimos el puerto 8080/tcp y levantamos un servidor web de prueba
echo "-> [serverb]: Abriendo el puerto $PUERTO/tcp en el Firewall y levantando servicio..."
ssh student@serverb "echo student | sudo -S firewall-cmd --add-port=${PUERTO}/tcp >/dev/null 2>&1; echo student | sudo -S firewall-cmd --list-ports 2>/dev/null; nohup python3 -m http.server $PUERTO </dev/null >/dev/null 2>&1 &"
sleep 2
echo ""

echo "--- PRUEBA DE CONEXION AL PUERTO $PUERTO ---"
# 'curl' intenta conectarse por HTTP al puerto 8080 de ambos servidores:
# En 'servera' falla porque su Firewall bloquea el puerto; en 'serverb' entra porque esta permitido.
echo "1) Intentando conectar a servera:$PUERTO (Puerto BLOQUEADO por Firewall):"
if curl -s --connect-timeout 2 http://servera:$PUERTO >/dev/null; then
    echo "   [OK]: Conectado a servera."
else
    echo "   [BLOQUEADO]: El Firewall de 'servera' rechazo la conexion al puerto $PUERTO."
fi

echo "2) Intentando conectar a serverb:$PUERTO (Puerto HABILITADO en Firewall):"
if curl -s --connect-timeout 2 http://serverb:$PUERTO >/dev/null; then
    echo "   [PERMITIDO]: Conexion exitosa con 'serverb' en el puerto $PUERTO."
else
    echo "   [AVISO]: No se pudo conectar a serverb:$PUERTO."
fi
echo ""

echo "========================================================================"
echo " 2. CREACION DE USUARIO ('auditor') Y CONTRASENA CON HASH EN /etc/shadow"
echo "========================================================================"
# 'useradd -m' crea el usuario 'auditor' con su carpeta personal (/home/auditor)
sudo useradd -m auditor 2>/dev/null
# 'chpasswd' asigna la contrasena; Linux guarda su Hash + Salt en /etc/shadow
echo "auditor:RedHat2026" | sudo chpasswd
echo "[OK]: Usuario 'auditor' creado. Contrasena guardada como Hash + Salt en /etc/shadow:"
sudo grep "^auditor:" /etc/shadow
echo ""

echo "========================================================================"
echo " 3. LISTA DE CONTROL DE ACCESO (ACL) PARA EL USUARIO 'auditor'"
echo "========================================================================"
ARCHIVO="/tmp/reporte_confidencial.txt"
echo "DATOS SECRETOS DEL SERVIDOR RED HAT" > $ARCHIVO
# 'chmod 600' cierra el archivo: solo el dueno puede leer y escribir; el resto no tiene permisos
chmod 600 $ARCHIVO

echo "-> Otorgando permiso de lectura SOLO a 'auditor' mediante ACL (setfacl):"
# 'setfacl -m u:auditor:r--' agrega un permiso de lectura exclusivo para 'auditor'
setfacl -m u:auditor:r-- $ARCHIVO
# 'ls -l' muestra un signo '+' al final de los permisos indicando que tiene una ACL activa
ls -l $ARCHIVO
# 'getfacl' muestra el detalle de la ACL aplicada
getfacl $ARCHIVO
echo "-> Probando leer el archivo con el usuario 'auditor':"
sudo su - auditor -c "cat $ARCHIVO"
rm -f $ARCHIVO
echo ""

echo "========================================================================"
echo " 4. INTEGRIDAD CON HASH SHA-256 ANTE MODIFICACION DE 'pagos_empresa.sh'"
echo "========================================================================"
# Nos aseguramos de que pagos_empresa.sh este sano y con permisos 750
sed -i '/VIRUS/d' pagos_empresa.sh
chmod 750 pagos_empresa.sh

echo "-> 4.1 Guardamos la huella digital oficial (SHA-256) de pagos_empresa.sh sano:"
# 'sha256sum' calcula el resumen de 256 bits del archivo original y lo guarda en 'sumacomp.txt'
sha256sum pagos_empresa.sh > sumacomp.txt
cat sumacomp.txt
echo ""

echo "-> 4.2 Ejecucion normal (verificando la huella antes de correr):"
# 'sha256sum -c' recalcula la huella actual y la compara con sumacomp.txt; si da OK, ejecuta el script
if sha256sum -c sumacomp.txt; then
    echo "[AUTORIZADO]: La huella coincide. Ejecutando pagos_empresa.sh:"
    ./pagos_empresa.sh
fi
echo ""

echo "-> 4.3 EL PROBLEMA: Un intruso/virus agrega una linea maliciosa a pagos_empresa.sh:"
echo 'echo "[VIRUS]: Robando contrasenas..."' >> pagos_empresa.sh
echo "Ultima linea agregada al archivo: $(tail -n 1 pagos_empresa.sh)"
echo ""

echo "-> 4.4 LA SOLUCION: El comprobador detecta que el Hash cambio y bloquea la ejecucion:"
if sha256sum -c sumacomp.txt; then
    ./pagos_empresa.sh
else
    echo "[BLOQUEADO]: La huella SHA-256 NO coincide. El archivo fue modificado y su ejecucion se cancelo."
fi
echo ""

echo "-> 4.5 Restaurando el archivo original y limpiando el entorno:"
# Quitamos la linea maliciosa con 'sed', borramos sumacomp.txt y volvemos a dejar abierto el puerto en servera
sed -i '/VIRUS/d' pagos_empresa.sh
rm -f sumacomp.txt
ssh student@servera "echo student | sudo -S firewall-cmd --add-port=${PUERTO}/tcp >/dev/null 2>&1" 2>/dev/null
echo "[OK]: Archivo pagos_empresa.sh restaurado y entorno limpio."
