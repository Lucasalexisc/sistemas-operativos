#!/bin/bash
# ==============================================================================
# UNIDAD 6 - OPCION 2: DEMOSTRACION LOCAL COMPLETA (opcion2_local_completo.sh)
# Reune en un solo servidor Red Hat las 4 capas de Defensa en Profundidad:
#   1) Estado de red (ss -tuln) y Firewall local (firewall-cmd)
#   2) Creacion de usuario ('auditor') y auditoria de Hash + Salt en /etc/shadow
#   3) Control de Acceso con ACL (setfacl / getfacl)
#   4) Comprobador de Integridad con Hash SHA-256 (sha256sum -c)
# ==============================================================================

echo "========================================================================"
echo " 1. PUERTOS EN ESCUCHA (ss -tuln) Y REGLAS DE FIREWALL (firewall-cmd)"
echo "========================================================================"
# 'ss -tuln' lista los puertos TCP/UDP que estan abiertos escuchando conexiones en el servidor
ss -tuln | head -n 8
echo ""
# Si firewalld esta activo, demostramos como abrir (--add-port) y cerrar (--remove-port) el puerto 8080/tcp
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
# Creamos el usuario 'auditor', le asignamos clave y mostramos como Linux guarda el Hash + Salt en /etc/shadow
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
# Cerramos el archivo con chmod 600 (nadie salvo el dueno tiene permiso)
chmod 600 $ARCHIVO

# Con 'setfacl -m' otorgamos permiso de lectura (r--) especificamente al usuario autorizado
if id auditor >/dev/null 2>&1; then
    setfacl -m u:auditor:r-- $ARCHIVO
    echo "[OK]: Permiso de lectura otorgado a 'auditor' con setfacl:"
else
    setfacl -m u:$(whoami):r-- $ARCHIVO
fi
# En 'ls -l' aparece un signo '+' al final de los permisos indicando que tiene una ACL activa
ls -l $ARCHIVO
getfacl $ARCHIVO
rm -f $ARCHIVO
echo ""

echo "========================================================================"
echo " 4. COMPROBADOR DE INTEGRIDAD ANTI-VIRUS (HASH SHA-256 EN 'sumacomp.txt')"
echo "========================================================================"
# Nos aseguramos de que pagos_empresa.sh este sano y con permisos restringidos 750
sed -i '/VIRUS/d' pagos_empresa.sh
chmod 750 pagos_empresa.sh

echo "-> 4.1 Guardamos la huella digital (SHA-256) de pagos_empresa.sh sano:"
# 'sha256sum' calcula el Hash de 256 bits del script original y lo guarda en 'sumacomp.txt'
sha256sum pagos_empresa.sh > sumacomp.txt
cat sumacomp.txt

echo "-> 4.2 Verificamos antes de ejecutar:"
# 'sha256sum -c' recalcula el Hash actual y lo compara con sumacomp.txt; si da OK, ejecuta el script
if sha256sum -c sumacomp.txt; then
    ./pagos_empresa.sh
fi
echo ""

echo "-> 4.3 Un intruso/virus modifica pagos_empresa.sh:"
# Simulamos que un atacante inyecta una linea maliciosa al final del archivo con '>>'
echo 'echo "[VIRUS]: Robando contrasenas..."' >> pagos_empresa.sh

echo "-> 4.4 El Comprobador de Integridad detecta que el Hash cambio y bloquea:"
# Al volver a validar con 'sha256sum -c', el Hash cambia por completo (Efecto Avalancha),
# devuelve FAILED y el bloque 'else' cancela la ejecucion impidiendo que corra el virus.
if sha256sum -c sumacomp.txt; then
    ./pagos_empresa.sh
else
    echo "[BLOQUEADO]: PELIGRO! El Hash SHA-256 no coincide. Ejecucion cancelada!"
fi

# Limpiamos la linea maliciosa con 'sed' y borramos el archivo temporal sumacomp.txt
sed -i '/VIRUS/d' pagos_empresa.sh
rm -f sumacomp.txt
