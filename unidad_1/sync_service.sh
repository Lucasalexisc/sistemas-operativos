#!/bin/bash
DATA_FILE="/etc/secure_app/transactions.dat"

echo "[INFO] Iniciando el servicio de conciliacion..."

if [ ! -r "$DATA_FILE" ]; then
   echo "[ERROR FATAL 101]: Fallo critico en el motor transaccional. Contacte a soporte de IT." >&2
    exit 101
fi

cat "$DATA_FILE"
exit 0
