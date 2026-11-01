#!/bin/bash
# ==============================================================================
# RESTAURAR FALLA - UNIDAD 1 (restaurar_falla.sh)
# Elimina la carpeta /etc/secure_app para volver a dejar el servidor con la falla
# original (ENOENT) y poder repetir la demostracion en vivo frente al profesor.
# ==============================================================================

echo "--- 1. ELIMINANDO /etc/secure_app Y EL ARCHIVO transactions.dat ---"
# Borramos el directorio creado en /etc y limpiamos los archivos de log temporales
sudo rm -rf /etc/secure_app
rm -f auditoria_archivos.log auditoria_ok.log

echo "--- 2. COMPROBANDO QUE EL SERVICIO VUELVE A FALLAR CON ERROR 101 ---"
./sync_service.sh
echo "Codigo de salida: $?"
