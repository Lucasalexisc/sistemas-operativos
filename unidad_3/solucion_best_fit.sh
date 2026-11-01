#!/bin/bash
# ==============================================================================
# SOLUCION - UNIDAD 3 (solucion_best_fit.sh)
#   Problema: con First-Fit el proceso P4 (426 KB) es RECHAZADO aunque sobran 959 KB.
#   Solucion: 1) Reemplazar First-Fit por Best-Fit en la asignacion contigua.
#             2) Mostrar como lo resuelve Red Hat Linux en la realidad: mediante
#                PAGINACION (dividiendo la RAM en paginas fijas de 4096 bytes).
# ==============================================================================

if ! command -v gcc >/dev/null 2>&1; then
    echo "[ERROR]: 'gcc' no esta instalado. Ejecute: cd .. && ./preparar_todo.sh"
    exit 1
fi

echo "============================================================"
echo " 1. COMPILANDO EL SIMULADOR"
echo "============================================================"
gcc simulador_memoria.c -o simulador_memoria
if [ $? -ne 0 ]; then
    echo "[ERROR]: Fallo la compilacion."
    exit 1
fi
echo "[OK]: Binario 'simulador_memoria' generado."
echo ""

echo "============================================================"
echo " 2. ANTES: PROCESOS RECHAZADOS CON FIRST-FIT"
echo "============================================================"
# 'grep -c' cuenta cuantas lineas de la salida contienen la palabra RECHAZADO
RECHAZADOS_F=$(./simulador_memoria F | grep -c "RECHAZADO")
echo "Procesos rechazados con First-Fit: $RECHAZADOS_F"
echo ""

echo "============================================================"
echo " 3. DESPUES: APLICANDO BEST-FIT"
echo "============================================================"
# Ejecutamos con Best-Fit (parametro B), mostramos la tabla y contamos rechazados
SALIDA_B=$(./simulador_memoria B)
echo "$SALIDA_B"
RECHAZADOS_B=$(echo "$SALIDA_B" | grep -c "RECHAZADO")
echo ""

echo "============================================================"
echo " 4. VERIFICACION DE LA SOLUCION"
echo "============================================================"
echo "Rechazados con First-Fit: $RECHAZADOS_F | Rechazados con Best-Fit: $RECHAZADOS_B"
if [ "$RECHAZADOS_B" -eq 0 ]; then
    echo "[RESULTADO]: Con Best-Fit los 4 procesos fueron asignados. Problema resuelto."
else
    echo "[RESULTADO]: Best-Fit todavia rechaza $RECHAZADOS_B proceso(s)."
fi
echo ""

echo "============================================================"
echo " 5. COMO LO RESUELVE LINUX EN LA REALIDAD: PAGINACION"
echo "============================================================"
# 'getconf PAGESIZE' consulta al Kernel el tamano de marco de pagina (4096 bytes = 4 KB)
echo "Tamano de pagina usado por este Red Hat (bytes): $(getconf PAGESIZE)"
echo "Linux no necesita huecos contiguos: divide la memoria en paginas de ese tamano."
# 'free -h' muestra el estado real de la memoria RAM y Swap del servidor Red Hat
free -h
