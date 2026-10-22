#!/bin/bash
# ==============================================================================
# MENU OPCIONAL DE EJECUCION RAPIDA - TPO SISTEMAS OPERATIVOS (UNIDADES 1 A 6)
# Uso: ./menu_tpo.sh       (muestra el menu interactivo)
#   o: ./menu_tpo.sh [1-6] (ejecuta directamente esa unidad)
# ==============================================================================

chmod +x unidad_*/*.sh 2>/dev/null

if [ -n "$1" ]; then
    OPCION="$1"
else
    echo "=================================================================="
    echo "   TRABAJO PRACTICO OBLIGATORIO - SISTEMAS OPERATIVOS (RED HAT)   "
    echo "=================================================================="
    echo "  1) Unidad 1 - Introduccion y Syscalls (audit_syscalls.sh)"
    echo "  2) Unidad 2 - Procesos, Hilos y Mutex (demostracion_tpo.sh)"
    echo "  3) Unidad 3 - Memoria: First-Fit vs Best-Fit (ejecutar_tpo.sh)"
    echo "  4) Unidad 4 - Archivos: Contiguo vs Inodos (ejecutar_tpo.sh)"
    echo "  5) Unidad 5 - Entrada/Salida: Sin Bufer vs Con Bufer (ejecutar_tpo.sh)"
    echo "  6) Unidad 6 - Seguridad: Integridad Hash y ACL (ejecutar_tpo.sh)"
    echo "  0) Salir"
    echo "------------------------------------------------------------------"
    read -p "Seleccione el numero de unidad a ejecutar [1-6]: " OPCION
    echo ""
fi

case $OPCION in
    1) cd unidad_1 && ./audit_syscalls.sh ;;
    2) cd unidad_2 && ./demostracion_tpo.sh ;;
    3) cd unidad_3 && ./ejecutar_tpo.sh ;;
    4) cd unidad_4 && ./ejecutar_tpo.sh ;;
    5) cd unidad_5 && ./ejecutar_tpo.sh ;;
    6) cd unidad_6 && ./ejecutar_tpo.sh ;;
    0) echo "Saliendo..."; exit 0 ;;
    *) echo "[ERROR]: Opcion invalida. Elija un numero del 1 al 6."; exit 1 ;;
esac
