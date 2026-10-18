#!/bin/bash
# ==============================================================================
# SCRIPT DE AUTOMATIZACION Y AUDITORIA - TRABAJO PRACTICO OBLIGATORIO UNIDAD 4
# SISTEMAS OPERATIVOS (UADE) - RED HAT ENTERPRISE LINUX
# TEMA: SISTEMA DE ARCHIVOS - ASIGNACION CONTIGUA VS NODOS-I (INODES EXT4)
# ==============================================================================

echo "========================================================================"
echo " 1. COMPILACION DEL SIMULADOR DEL SISTEMA DE ARCHIVOS (GCC EN RED HAT)"
echo "========================================================================"
gcc -Wall -O2 simulador_filesystem.c -o simulador_filesystem
if [ $? -ne 0 ]; then
    echo "[ERROR FATAL]: Fallo critico durante la compilacion de simulador_filesystem.c"
    exit 1
fi
echo "[OK]: Compilacion exitosa. Binario 'simulador_filesystem' generado."
echo ""

echo "========================================================================"
echo " 2. EJECUCION: ASIGNACION CONTIGUA CON PRIMER AJUSTE (FIRST-FIT)"
echo "========================================================================"
./simulador_filesystem F
echo ""

echo "========================================================================"
echo " 3. EJECUCION: ASIGNACION CONTIGUA CON MEJOR AJUSTE (BEST-FIT)"
echo "========================================================================"
./simulador_filesystem B
echo ""

echo "========================================================================"
echo " 4. EJECUCION: ASIGNACION INDEXADA CON NODOS-I (INODES - EXT4 RED HAT)"
echo "========================================================================"
./simulador_filesystem I
echo ""

echo "========================================================================"
echo " 5. COMPARATIVA DE TIEMPOS DE ASIGNACION (BENCHMARKING)"
echo "========================================================================"
echo "--- Tiempo Asignacion Contigua (First-Fit) ---"
time ./simulador_filesystem F > /dev/null
echo ""
echo "--- Tiempo Asignacion Indexada (Nodos-i ext4) ---"
time ./simulador_filesystem I > /dev/null
echo ""

echo "========================================================================"
echo " 6. AUDITORIA FORENSE CON HERRAMIENTAS NATIVAS DE CONSOLA DE RED HAT"
echo "========================================================================"

TEST_FILE="prueba_inodo.dat"
echo "Creando archivo de prueba con dd para auditar metadatos en ext4..."
dd if=/dev/urandom of=$TEST_FILE bs=4096 count=3 status=none

echo ""
echo "--- 6.1 Auditoria de Inodo y Bloques Fisicos con 'stat' ---"
stat $TEST_FILE
echo ""

echo "--- 6.2 Visualizacion del Numero de Inodo en Directorio con 'ls -li' ---"
ls -li $TEST_FILE
echo ""

echo "--- 6.3 Auditoria de Espacio Libre en Bloques y en Inodos ('df -h' y 'df -i') ---"
df -h .
echo ""
df -i .
echo ""

echo "--- 6.4 Verificacion de Numero Magico y Tipo de Archivo con 'file' ---"
file $TEST_FILE
file simulador_filesystem.c
file simulador_filesystem
echo ""

# Limpieza del archivo de prueba
rm -f $TEST_FILE
echo "[OK]: Auditoria forense finalizada y archivos temporales liberados con exito."
