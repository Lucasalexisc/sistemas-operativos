#!/bin/bash
# ==============================================================================
# UNIDAD 6 - OPCION 2: DEMOSTRACION LOCAL COMPLETA EN UN SOLO SERVIDOR RED HAT
# 1) Estado de red y Firewall local (bloquear vs abrir puerto con firewall-cmd)
# 2) Crear usuario ('auditor') y ver su Hash + Salt en /etc/shadow
# 3) Control de Acceso con ACL (setfacl / getfacl)
# 4) Comprobador de Integridad con Hash SHA-256 (sha256sum -c)
# ==============================================================================

echo "========================================================================"
echo " 1. PUERTOS EN ESCUCHA (ss -tuln) Y REGLAS DE FIREWALL (firewall-cmd)"
echo "========================================================================"
ss -tuln | head -n 8
echo ""
if command -v firewall-cmd >/dev/null 2>&1; then
    echo "-> Abriendo puerto 8080/tcp (como en serverb):"
    sudo firewall-cmd --add-port=8080/tcp
    echo "   Puertos abiertos actualmente: $(sudo firewall-cmd --list-ports)"
    echo "-> Cerrando/bloqueando puerto 8080/tcp (como en servera):"
    sudo firewall-cmd --remove-port=8080/tcp
    echo "   Puertos abiertos actualmente: $(sudo firewall-cmd --list-ports)"
else
    echo "[INFO]: En Red Hat usamos 'sudo firewall-cmd --add-port=8080/tcp' y '--remove-port=8080/tcp'"
fi
echo ""

echo "========================================================================"
echo " 2. CREAR USUARIO ('auditor') Y VER SU HASH + SALT EN /etc/shadow"
echo "========================================================================"
if [ "$(id -u)" -eq 0 ] || sudo -n true 2>/dev/null; then
    sudo useradd -m auditor 2>/dev/null
    echo "auditor:RedHat2026" | sudo chpasswd
    echo "[OK]: Usuario 'auditor' configurado. Entrada real en /etc/shadow:"
    sudo grep "^auditor:" /etc/shadow
else
    echo "[INFO]: Ejecutando con sudo en Red Hat se crea el usuario 'auditor' y se ve su Hash+Salt en /etc/shadow."
fi
echo ""

echo "========================================================================"
echo " 3. LISTA DE CONTROL DE ACCESO (ACL) PARA EL USUARIO AUTORIZADO"
echo "========================================================================"
ARCHIVO="/tmp/reporte_confidencial.txt"
echo "DATOS SECRETOS DEL SERVIDOR RED HAT" > $ARCHIVO
chmod 600 $ARCHIVO

if id auditor >/dev/null 2>&1; then
    setfacl -m u:auditor:r-- $ARCHIVO
    echo "[OK]: Permiso de lectura otorgado a 'auditor' con setfacl:"
else
    setfacl -m u:$(whoami):r-- $ARCHIVO
fi
ls -l $ARCHIVO
getfacl $ARCHIVO
rm -f $ARCHIVO
echo ""

echo "========================================================================"
echo " 4. COMPROBADOR DE INTEGRIDAD ANTI-VIRUS (HASH SHA-256 EN 'sumacomp.txt')"
echo "========================================================================"
sed -i '/VIRUS/d' pagos_empresa.sh
chmod 750 pagos_empresa.sh

echo "-> 4.1 Guardamos la huella digital (SHA-256) de pagos_empresa.sh sano:"
sha256sum pagos_empresa.sh > sumacomp.txt
cat sumacomp.txt

echo "-> 4.2 Verificamos antes de ejecutar:"
if sha256sum -c sumacomp.txt; then
    ./pagos_empresa.sh
fi
echo ""

echo "-> 4.3 Un intruso/virus modifica pagos_empresa.sh:"
echo 'echo "[VIRUS]: Robando contrasenas..."' >> pagos_empresa.sh

echo "-> 4.4 El Comprobador de Integridad detecta que el Hash cambio y bloquea:"
if sha256sum -c sumacomp.txt; then
    ./pagos_empresa.sh
else
    echo "[BLOQUEADO]: PELIGRO! El Hash SHA-256 no coincide. Ejecucion cancelada!"
fi

sed -i '/VIRUS/d' pagos_empresa.sh
rm -f sumacomp.txt
