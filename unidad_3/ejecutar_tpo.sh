#!/bin/bash
if ! command -v gcc >/dev/null 2>&1; then
    echo "============================================================"
    echo " [ERROR]: 'gcc' no esta instalado en este sistema Red Hat."
    echo " Para instalarlo automaticamente junto a las demas herramientas:"
    echo "   cd .. && ./preparar_todo.sh"
    echo " O manualmente: sudo dnf install -y --disablerepo='*ansible*' gcc"
    echo "============================================================"
    exit 1
fi

echo "============================================================"
echo " COMPILANDO EL SIMULADOR EN C CON GCC (RED HAT)"
echo "============================================================"
gcc simulador_memoria.c -o simulador_memoria
if [ $? -ne 0 ]; then
    echo "[ERROR] Fallo critico en la compilacion."
    exit 1
fi
echo "[OK] Binario 'simulador_memoria' generado con exito."
echo ""

echo "============================================================"
echo " 1. EJECUCION CON PRIMER AJUSTE (FIRST-FIT)"
echo "============================================================"
./simulador_memoria F
echo ""

echo "============================================================"
echo " 2. EJECUCION CON MEJOR AJUSTE (BEST-FIT)"
echo "============================================================"
./simulador_memoria B
echo ""

echo "============================================================"
echo " 3. ANALISIS COMPARATIVO DE TIEMPOS DE EJECUCION"
echo "============================================================"
echo "--- Tiempo First-Fit ---"
time ./simulador_memoria F > /dev/null
echo ""
echo "--- Tiempo Best-Fit ---"
time ./simulador_memoria B > /dev/null
