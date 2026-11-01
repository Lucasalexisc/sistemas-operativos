#!/bin/bash
# ==============================================================================
# UNIDAD 1 - SERVICIO BANCARIO DE CONCILIACION (sync_service.sh)
# Este script simula el programa de la empresa que falla con 'ERROR FATAL 101'
# sin indicar la causa real. Lo auditaremos desde afuera con 'strace'.
# ==============================================================================

# 1. Guardamos en la variable DATA_FILE la ruta del archivo de transacciones
DATA_FILE="/etc/secure_app/transactions.dat"

# 2. Mostramos en pantalla (stdout - descriptor 1) que el servicio comienza
echo "[INFO] Iniciando el servicio de conciliacion..."

# 3. Verificamos si el archivo NO se puede leer:
#    -r comprueba si el archivo existe y tiene permisos de lectura (invoca la syscall faccessat2).
#    !  niega la condicion (entra al if si NO existe o NO tiene permisos).
if [ ! -r "$DATA_FILE" ]; then
    # >&2 envia el mensaje por el canal estandar de errores (stderr - descriptor 2)
    echo "[ERROR FATAL 101]: Fallo critico en el motor transaccional. Contacte a soporte de IT." >&2
    # Cortamos la ejecucion devolviendo el codigo de error 101 (distinto de 0 = fallo)
    exit 101
fi

# 4. Si el archivo existe y tiene permisos de lectura, mostramos su contenido con 'cat'
cat "$DATA_FILE"

# 5. Finalizamos devolviendo 0 (convencion en Linux para indicar ejecucion exitosa)
exit 0
