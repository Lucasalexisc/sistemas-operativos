#!/bin/bash
# ==============================================================================
# SCRIPT PRINCIPAL - UNIDAD 6: SEGURIDAD EN RED HAT (ejecutar_tpo.sh)
# Permite elegir en vivo entre las 2 opciones de demostracion frente al profesor:
#   Opcion 1: Entre servidores en red (workstation -> servera bloqueado vs serverb abierto + ACL)
#   Opcion 2: Demostracion local completa (Firewall, Usuario /etc/shadow, ACL y Hash SHA-256)
# ==============================================================================

# 1. Nos aseguramos de que todos los scripts de la Unidad 6 tengan permiso de ejecucion (+x)
chmod +x opcion1_servers_remotos.sh opcion2_local_completo.sh pagos_empresa.sh 2>/dev/null

# 2. Si el usuario paso la opcion como parametro (ej: ./ejecutar_tpo.sh 2), la usamos directo;
#    si no paso nada, mostramos el menu interactivo con 'read -p'.
if [ -n "$1" ]; then
    MODO="$1"
else
    echo "========================================================================"
    echo "   UNIDAD 6 - SEGURIDAD EN SISTEMAS OPERATIVOS (RED HAT LINUX)          "
    echo "========================================================================"
    echo "  1) OPCION 1: Laboratorio con 'servera' (puerto bloqueado) y 'serverb' (abierto) + Usuario/ACL"
    echo "  2) OPCION 2: Demostracion en un solo servidor (Firewall, Usuario, ACL y Hash SHA-256)"
    echo "------------------------------------------------------------------------"
    read -p "Seleccione que opcion desea mostrar [1 o 2] (Enter = Opcion 2): " MODO
    # Si el usuario presiona Enter vacio, por defecto toma la Opcion 2
    MODO=${MODO:-2}
    echo ""
fi

# 3. Ejecutamos el script correspondiente segun la opcion elegida
if [ "$MODO" = "1" ]; then
    ./opcion1_servers_remotos.sh
else
    ./opcion2_local_completo.sh
fi
