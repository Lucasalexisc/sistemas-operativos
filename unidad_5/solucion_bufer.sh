#!/bin/bash
# ==============================================================================
# SOLUCION - UNIDAD 5: reemplazar la escritura de a 1 byte por escritura con bufer
#   Problema: sin_bufer.c hace 100.000 llamadas a write() (una por letra).
#   Solucion: con_bufer.c junta 4000 letras en memoria y escribe en 25 llamadas.
# Uso: ./solucion_bufer.sh
# ==============================================================================

if ! command -v gcc >/dev/null 2>&1 || ! command -v strace >/dev/null 2>&1; then
    echo "[ERROR]: Falta 'gcc' o 'strace'. Ejecute: cd .. && ./preparar_todo.sh"
    exit 1
fi

echo "============================================================"
echo " 1. COMPILANDO LA VERSION CORREGIDA (con_bufer.c)"
echo "============================================================"
gcc con_bufer.c -o con_bufer
if [ $? -ne 0 ]; then
    echo "[ERROR]: Fallo la compilacion."
    exit 1
fi
echo "[OK]: Binario 'con_bufer' generado."
echo ""

echo "============================================================"
echo " 2. EJECUTANDO LA VERSION CON BUFER Y MIDIENDO EL TIEMPO"
echo "============================================================"
time ./con_bufer
echo ""

echo "============================================================"
echo " 3. VERIFICANDO QUE EL ARCHIVO TIENE LOS 100.000 BYTES"
echo "============================================================"
TAMANO=$(stat -c %s salida_rapida.txt)
echo "Tamano de salida_rapida.txt: $TAMANO bytes"
echo ""

echo "============================================================"
echo " 4. CONTANDO LAS LLAMADAS AL SISTEMA 'write' CON STRACE"
echo "============================================================"
strace -c -e trace=write -o conteo_write.txt ./con_bufer > /dev/null
cat conteo_write.txt
LLAMADAS=$(awk '$NF=="write" {print $4}' conteo_write.txt)
echo ""

echo "============================================================"
echo " 5. VERIFICACION DE LA SOLUCION"
echo "============================================================"
if [ "$TAMANO" -eq 100000 ]; then
    echo "[RESULTADO]: Se escribieron los 100.000 bytes usando solo $LLAMADAS llamadas a write"
    echo "             (contra 100.001 de la version sin bufer). Problema resuelto."
else
    echo "[RESULTADO]: El archivo no tiene el tamano esperado ($TAMANO bytes)."
fi

rm -f salida_rapida.txt conteo_write.txt
