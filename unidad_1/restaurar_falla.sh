#!/bin/bash
# ==============================================================================
# RESTAURAR FALLA - UNIDAD 1: vuelve a dejar el servidor con el problema original
# Sirve para repetir la demostracion desde cero (falla -> auditoria -> solucion).
# Uso: ./restaurar_falla.sh   (pide la clave de sudo porque borra en /etc)
# ==============================================================================

echo "--- 1. ELIMINANDO /etc/secure_app Y EL ARCHIVO transactions.dat ---"
sudo rm -rf /etc/secure_app
rm -f auditoria_archivos.log auditoria_ok.log

echo "--- 2. COMPROBANDO QUE EL SERVICIO VUELVE A FALLAR ---"
./sync_service.sh
echo "Codigo de salida: $?"
