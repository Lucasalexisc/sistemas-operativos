#!/bin/bash
# ==============================================================================
# SOLUCION - UNIDAD 1: crea el archivo que 'sync_service.sh' no encontraba
# Causa raiz (detectada con strace): faccessat2(".../transactions.dat") = -1 ENOENT
# Uso: ./reparar_servicio.sh   (pide la clave de sudo porque escribe en /etc)
# ==============================================================================

echo "--- 1. CREANDO EL DIRECTORIO /etc/secure_app ---"
sudo mkdir -p /etc/secure_app

echo "--- 2. CREANDO EL ARCHIVO transactions.dat CON DATOS DE PRUEBA ---"
sudo bash -c 'cat << EOF > /etc/secure_app/transactions.dat
TXN_ID: 10001 | MONTO: 15420.50 | ESTADO: APROBADO
TXN_ID: 10002 | MONTO: 8930.00  | ESTADO: APROBADO
TXN_ID: 10003 | MONTO: 42100.75 | ESTADO: APROBADO
EOF'

echo "--- 3. ASIGNANDO PERMISOS DE LECTURA (644) ---"
sudo chmod 644 /etc/secure_app/transactions.dat
ls -l /etc/secure_app/

echo "--- 4. VOLVIENDO A EJECUTAR EL SERVICIO ---"
./sync_service.sh
echo "Codigo de salida: $?"

echo "--- 5. CONFIRMANDO CON STRACE QUE EL KERNEL AHORA RESPONDE 0 (EXITO) ---"
strace -f -e trace=file -o auditoria_ok.log ./sync_service.sh > /dev/null
grep "transactions.dat" auditoria_ok.log
