#!/bin/bash
# ==============================================================================
# UNIDAD 1 - AUDITORIA DE LLAMADAS AL SISTEMA CON STRACE (audit_syscalls.sh)
# Objetivo: Descubrir por que falla 'sync_service.sh' sin modificar su codigo,
# interceptando la comunicacion entre Modo Usuario (Ring 3) y Modo Kernel (Ring 0).
# ==============================================================================

# 0. Verificamos que la herramienta 'strace' este instalada en Red Hat
#    command -v busca el binario; >/dev/null 2>&1 oculta la salida de verificacion
if ! command -v strace >/dev/null 2>&1; then
    echo "============================================================"
    echo " [ERROR]: 'strace' no esta instalado en este sistema Red Hat."
    echo " Para instalarlo automaticamente junto a las demas herramientas:"
    echo "   cd .. && ./preparar_todo.sh"
    echo " O manualmente: sudo dnf install -y --disablerepo='*ansible*' strace"
    echo "============================================================"
    exit 1
fi

# Otorgamos permiso de ejecucion (+x) al script que vamos a auditar
chmod +x ./sync_service.sh

echo "============================================================"
echo " 1. INTERCEPTANDO SYSCALLS CON STRACE"
echo "============================================================"
# Ejecutamos sync_service.sh monitoreado por strace:
#   -f               : sigue tambien a los procesos hijos creados por el script
#   -e trace=file    : filtra solo llamadas al sistema que tocan archivos (openat, faccessat2, stat)
#   -o auditoria...  : guarda el registro completo en un archivo de texto en vez de saturar la pantalla
strace -f -e trace=file -o auditoria_archivos.log ./sync_service.sh

echo ""
echo "============================================================"
echo " 2. DIAGNOSTICO: CAUSA RAIZ DETECTADA A NIVEL KERNEL"
echo "============================================================"
# Usamos 'grep' para buscar dentro del log unicamente la linea referida a 'transactions.dat'.
# Aqui se ve que la syscall faccessat2 devuelve '-1 ENOENT (No such file or directory)'.
grep "transactions.dat" auditoria_archivos.log

echo ""
echo "============================================================"
echo " 3. TABLA ESTADISTICA DE LLAMADAS AL SISTEMA (-c)"
echo "============================================================"
# Ejecutamos strace con '-c' (count) para armar una tabla resumen que muestra:
# cantidad de llamadas (calls), errores (errors) y tiempo de CPU consumido en Modo Kernel.
strace -c -e trace=execve,openat,read,write,close,newfstatat,faccessat2 ./sync_service.sh
