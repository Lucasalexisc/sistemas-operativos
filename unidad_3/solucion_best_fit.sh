#!/bin/bash
# ==============================================================================
# SOLUCION - UNIDAD 3: reemplazar First-Fit por Best-Fit
#   Problema: con First-Fit el proceso P4 (426 KB) es RECHAZADO aunque sobran 959 KB.
#   Solucion: con Best-Fit cada proceso usa el hueco mas justo y P4 entra.
# Uso: ./solucion_best_fit.sh
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
RECHAZADOS_F=$(./simulador_memoria F | grep -c "RECHAZADO")
echo "Procesos rechazados con First-Fit: $RECHAZADOS_F"
echo ""

echo "============================================================"
echo " 3. DESPUES: APLICANDO BEST-FIT"
echo "============================================================"
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
echo "Tamano de pagina usado por este Red Hat (bytes): $(getconf PAGESIZE)"
echo "Linux no necesita huecos contiguos: divide la memoria en paginas de ese tamano."
free -h
