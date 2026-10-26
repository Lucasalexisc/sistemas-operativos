#!/bin/bash
# ==============================================================================
# UNIDAD 6 - OPCION 1: SEGURIDAD ENTRE SERVIDORES RED HAT (servera y serverb)
# 1) Ver como se conectan por red (ping y puertos)
# 2) Firewall (firewall-cmd): Bloquear puerto 8080 en servera y abrirlo en serverb
# 3) Crear usuario autorizado (useradd + /etc/shadow) y darle acceso con ACL
# ==============================================================================

PUERTO=8080

echo "========================================================================"
echo " 1. VERIFICANDO CONECTIVIDAD DE RED CON 'servera' Y 'serverb'"
echo "========================================================================"
echo "-> Probando conexion con servera:"
ping -c 2 servera
echo ""
echo "-> Probando conexion con serverb:"
ping -c 2 serverb
echo ""

echo "========================================================================"
echo " 2. FIREWALL EN RED HAT: BLOQUEAR PUERTO EN 'servera' Y ABRIR EN 'serverb'"
echo "========================================================================"
echo "-> [servera]: Bloqueando el puerto $PUERTO/tcp en el Firewall..."
ssh student@servera "echo student | sudo -S firewall-cmd --remove-port=${PUERTO}/tcp >/dev/null 2>&1; echo student | sudo -S firewall-cmd --list-ports 2>/dev/null"

echo "-> [serverb]: Abriendo el puerto $PUERTO/tcp en el Firewall y levantando servicio..."
ssh student@serverb "echo student | sudo -S firewall-cmd --add-port=${PUERTO}/tcp >/dev/null 2>&1; echo student | sudo -S firewall-cmd --list-ports 2>/dev/null; nohup python3 -m http.server $PUERTO </dev/null >/dev/null 2>&1 &"
sleep 2
echo ""

echo "--- PRUEBA DE CONEXION DESDE AFUERA AL PUERTO $PUERTO ---"
echo "1) Intentando conectar a servera:$PUERTO (Puerto BLOQUEADO por Firewall):"
if curl -s --connect-timeout 2 http://servera:$PUERTO >/dev/null; then
    echo "   [OK]: Conectado a servera."
else
    echo "   [BLOQUEADO]: El Firewall de 'servera' rechazo la conexion al puerto $PUERTO!"
fi

echo "2) Intentando conectar a serverb:$PUERTO (Puerto HABILITADO en Firewall):"
if curl -s --connect-timeout 2 http://serverb:$PUERTO >/dev/null; then
    echo "   [PERMITIDO]: Conexion exitosa con 'serverb' en el puerto $PUERTO!"
else
    echo "   [AVISO]: No se pudo conectar a serverb:$PUERTO."
fi
echo ""

echo "========================================================================"
echo " 3. CREACION DE USUARIO AUTORIZADO ('auditor') Y HASH CON SALT EN /etc/shadow"
echo "========================================================================"
sudo useradd -m auditor 2>/dev/null
echo "auditor:RedHat2026" | sudo chpasswd
echo "[OK]: Usuario 'auditor' creado."
echo "-> Viendo su contrasena cifrada con Hash + Salt aleatorio en /etc/shadow:"
sudo grep "^auditor:" /etc/shadow
echo ""

echo "========================================================================"
echo " 4. CONTROL DE ACCESO (ACL): DAR PERMISO EXCLUSIVO AL USUARIO 'auditor'"
echo "========================================================================"
ARCHIVO="/tmp/reporte_confidencial.txt"
echo "DATOS SECRETOS DEL SERVIDOR RED HAT" > $ARCHIVO
chmod 600 $ARCHIVO

echo "-> Otorgando permiso de lectura SOLO a 'auditor' mediante ACL (setfacl):"
setfacl -m u:auditor:r-- $ARCHIVO
getfacl $ARCHIVO
echo ""

echo "-> Probando leer el archivo con el usuario 'auditor':"
sudo su - auditor -c "cat $ARCHIVO"

rm -f $ARCHIVO
