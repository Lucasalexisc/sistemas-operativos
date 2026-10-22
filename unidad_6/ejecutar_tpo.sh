#!/bin/bash
# ==============================================================================
# SCRIPT PRINCIPAL - UNIDAD 6 (SEGURIDAD EN RED HAT)
# Permite elegir entre las 2 opciones para mostrarle al profesor:
#   Opcion 1: Entre servidores (workstation -> servera bloqueado vs serverb abierto + usuario)
#   Opcion 2: Demostracion local completa (Firewall, Usuario /etc/shadow, ACL y Hash SHA-256)
# ==============================================================================

chmod +x opcion1_servers_remotos.sh opcion2_local_completo.sh pagos_empresa.sh 2>/dev/null

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
    MODO=${MODO:-2}
    echo ""
fi

if [ "$MODO" = "1" ]; then
    ./opcion1_servers_remotos.sh
else
    ./opcion2_local_completo.sh
fi
