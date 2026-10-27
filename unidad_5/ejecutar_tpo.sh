#!/bin/bash
# ==============================================================================
# SCRIPT DE DEMOSTRACION - UNIDAD 5 (ENTRADA / SALIDA Y USO DE BUFER)
# ==============================================================================

if ! command -v gcc >/dev/null 2>&1 || ! command -v strace >/dev/null 2>&1; then
    echo "============================================================"
    echo " [ERROR]: 'gcc' o 'strace' no estan instalados en Red Hat."
    echo " Para instalar todo automaticamente:"
    echo "   cd .. && ./preparar_todo.sh"
    echo " O manualmente: sudo dnf install -y --disablerepo='*ansible*' gcc strace"
    echo "============================================================"
    exit 1
fi

echo "--- 1. COMPILANDO LOS DOS PROGRAMAS EN C ---"
gcc sin_bufer.c -o sin_bufer && gcc con_bufer.c -o con_bufer
if [ $? -ne 0 ]; then
    echo "[ERROR]: Fallo la compilacion."
    exit 1
fi
echo "[OK]: Compilados 'sin_bufer' y 'con_bufer'."
echo ""

echo "--- 2. EJECUCION LENTA: SIN BUFER (100.000 viajes al Kernel) ---"
time ./sin_bufer
echo ""

echo "--- 3. EJECUCION RAPIDA: CON BUFER (Solo 25 viajes al Kernel) ---"
time ./con_bufer
echo ""

echo "--- 4. CONTANDO LAS LLAMADAS AL SISTEMA 'write' CON STRACE ---"
echo "-> Cantidad de syscalls SIN BUFER:"
strace -c -e trace=write ./sin_bufer > /dev/null
echo ""
echo "-> Cantidad de syscalls CON BUFER:"
strace -c -e trace=write ./con_bufer > /dev/null

rm -f salida_lenta.txt salida_rapida.txt
