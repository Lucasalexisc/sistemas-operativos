#!/bin/bash
chmod +x ./sync_service.sh

echo "============================================================"
echo " 1. INTERCEPTANDO SYSCALLS CON STRACE"
echo "============================================================"
# -f sigue procesos hijos, -e trace=file intercepta llamadas al sistema de archivos
strace -f -e trace=file -o auditoria_archivos.log ./sync_service.sh

echo ""
echo "============================================================"
echo " 2. DIAGNOSTICO: CAUSA RAIZ DETECTADA A NIVEL KERNEL"
echo "============================================================"
# Filtramos la llamada sobre el archivo que retornó código de error
grep "transactions.dat" auditoria_archivos.log

echo ""
echo "============================================================"
echo " 3. TABLA ESTADISTICA DE LLAMADAS AL SISTEMA (-c)"
echo "============================================================"
# -c genera el resumen de llamadas, errores y tiempo de procesador en modo núcleo
strace -c -e trace=execve,openat,read,write,close,newfstatat,faccessat2 ./sync_service.sh 
