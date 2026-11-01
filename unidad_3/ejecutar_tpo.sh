#!/bin/bash
# ==============================================================================
# UNIDAD 3 - EJECUCION Y COMPARACION DE MEMORIA CONTIGUA (ejecutar_tpo.sh)
# Compila 'simulador_memoria.c' y compara dos algoritmos sobre los mismos 5 huecos
# de RAM (100, 500, 200, 300 y 600 KB) y 4 procesos (212, 417, 112 y 426 KB):
#   1) Modo F (First-Fit / Primer Ajuste): P4 (426 KB) es RECHAZADO por Fragmentacion Externa.
#   2) Modo B (Best-Fit / Mejor Ajuste)  : los 4 procesos logran entrar sin rechazos.
# ==============================================================================

# 0. Verificamos que el compilador 'gcc' este instalado en el servidor Red Hat
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
# 1. Compilamos el simulador y verificamos con $? que no haya habido errores
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
# 2. Pasamos el parametro 'F': asigna el PRIMER hueco donde entra el proceso.
#    Aqui P4 (426 KB) falla aunque sobran 959 KB libres en total (Fragmentacion Externa).
./simulador_memoria F
echo ""

echo "============================================================"
echo " 2. EJECUCION CON MEJOR AJUSTE (BEST-FIT)"
echo "============================================================"
# 3. Pasamos el parametro 'B': revisa todos los huecos y elige el mas ajustado.
#    Preserva el hueco grande de 600 KB y permite que P4 entre con exito.
./simulador_memoria B
echo ""

echo "============================================================"
echo " 3. ANALISIS COMPARATIVO DE TIEMPOS DE EJECUCION"
echo "============================================================"
# 4. Medimos el tiempo con 'time'. Redirigimos la salida de texto a /dev/null
#    para ver limpia unicamente la medicion de tiempos (real, user y sys).
echo "--- Tiempo First-Fit ---"
time ./simulador_memoria F > /dev/null
echo ""
echo "--- Tiempo Best-Fit ---"
time ./simulador_memoria B > /dev/null
