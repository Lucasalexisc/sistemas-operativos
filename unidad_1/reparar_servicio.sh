#!/bin/bash
# ==============================================================================
# SOLUCION - UNIDAD 1 (reparar_servicio.sh)
# Causa raiz detectada con strace: faccessat2(".../transactions.dat") = -1 ENOENT
# Como ni la carpeta '/etc/secure_app' ni el archivo 'transactions.dat' existen,
# este script los crea, asigna permisos de lectura y verifica que el servicio funcione.
# ==============================================================================

echo "--- 1. CREANDO EL DIRECTORIO /etc/secure_app ---"
# Usamos sudo porque '/etc' es un directorio del sistema protegido por root.
# El parametro -p crea el directorio sin dar error si ya existia previamente.
sudo mkdir -p /etc/secure_app

echo "--- 2. CREANDO EL ARCHIVO transactions.dat CON DATOS DE PRUEBA ---"
# Cargamos 3 transacciones dentro de /etc/secure_app/transactions.dat usando un bloque EOF
sudo bash -c 'cat << EOF > /etc/secure_app/transactions.dat
TXN_ID: 10001 | MONTO: 15420.50 | ESTADO: APROBADO
TXN_ID: 10002 | MONTO: 8930.00  | ESTADO: APROBADO
TXN_ID: 10003 | MONTO: 42100.75 | ESTADO: APROBADO
EOF'

echo "--- 3. ASIGNANDO PERMISOS DE LECTURA (644) ---"
# Ahora que el archivo YA existe en el disco, le damos permisos 644 (rw-r--r--):
# el propietario puede leer/escribir y el resto de los usuarios puede leerlo.
sudo chmod 644 /etc/secure_app/transactions.dat
ls -l /etc/secure_app/

echo "--- 4. VOLVIENDO A EJECUTAR EL SERVICIO ---"
# Ejecutamos nuevamente el servicio; $? muestra el codigo de salida (0 = sin errores)
./sync_service.sh
echo "Codigo de salida: $?"

echo "--- 5. CONFIRMANDO CON STRACE QUE EL KERNEL AHORA RESPONDE 0 (EXITO) ---"
# Repetimos la auditoria con strace para demostrar que faccessat2 ahora retorna '= 0'
strace -f -e trace=file -o auditoria_ok.log ./sync_service.sh > /dev/null
grep "transactions.dat" auditoria_ok.log
