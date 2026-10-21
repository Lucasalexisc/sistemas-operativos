#!/bin/bash
# ==============================================================================
# SCRIPT DE DEMOSTRACION - UNIDAD 4 (SISTEMA DE ARCHIVOS)
# ==============================================================================

echo "--- 1. COMPILANDO EL SIMULADOR DE DISCO ---"
gcc simulador_filesystem.c -o simulador_filesystem
if [ $? -ne 0 ]; then
    echo "[ERROR]: Fallo la compilacion."
    exit 1
fi
echo "[OK]: Compilado correctamente."
echo ""

echo "--- 2. PRUEBA CON ASIGNACION CONTIGUA (FIRST-FIT) ---"
./simulador_filesystem F
echo ""

echo "--- 3. PRUEBA CON ASIGNACION CONTIGUA (BEST-FIT) ---"
./simulador_filesystem B
echo ""

echo "--- 4. SOLUCION LINUX: ASIGNACION CON INODOS (EXT4) ---"
./simulador_filesystem I
echo ""

echo "--- 5. VIENDO UN INODO REAL EN LINUX (ls -li y stat) ---"
ls -li simulador_filesystem.c
echo ""
stat simulador_filesystem.c
echo ""
echo "--- 6. VIENDO EL TIPO DE ARCHIVO POR NUMERO MAGICO (file) ---"
file simulador_filesystem.c
file simulador_filesystem
