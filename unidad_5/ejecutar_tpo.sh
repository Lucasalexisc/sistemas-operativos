#!/bin/bash
# ==============================================================================
# UNIDAD 5 - DEMOSTRACION DE ENTRADA/SALIDA Y USO DE BUFER (ejecutar_tpo.sh)
# Compila y compara dos programas en C que escriben el mismo archivo de 100.000 bytes:
#   1) sin_bufer.c : escribe de a 1 byte por vez (100.000 llamadas a write -> Lento)
#   2) con_bufer.c : junta bloques de 4.000 bytes en RAM (solo 25 llamadas a write -> Rapido)
# ==============================================================================

# 0. Verificamos que tanto 'gcc' como 'strace' esten instalados en Red Hat
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
# Compilamos ambos programas encadenados con '&&' (el segundo compila si el primero salio bien)
gcc sin_bufer.c -o sin_bufer && gcc con_bufer.c -o con_bufer
if [ $? -ne 0 ]; then
    echo "[ERROR]: Fallo la compilacion."
    exit 1
fi
echo "[OK]: Compilados 'sin_bufer' y 'con_bufer'."
echo ""

echo "--- 2. EJECUCION LENTA: SIN BUFER (100.000 viajes al Kernel) ---"
# Medimos con 'time' cuanto tarda hacer 100.000 cambios de contexto (Modo Usuario <-> Modo Kernel)
time ./sin_bufer
echo ""

echo "--- 3. EJECUCION RAPIDA: CON BUFER (Solo 25 viajes al Kernel) ---"
# Medimos con 'time' cuanto tarda cuando juntamos de a 4.000 bytes en un bufer en memoria
time ./con_bufer
echo ""

echo "--- 4. CONTANDO LAS LLAMADAS AL SISTEMA 'write' CON STRACE ---"
# 'strace -c -e trace=write' cuenta exactamente cuantas veces cada programa invoco la syscall write
echo "-> Cantidad de syscalls SIN BUFER:"
strace -c -e trace=write ./sin_bufer > /dev/null
echo ""
echo "-> Cantidad de syscalls CON BUFER:"
strace -c -e trace=write ./con_bufer > /dev/null

# Borramos los archivos temporales de salida al terminar la demostracion
rm -f salida_lenta.txt salida_rapida.txt
