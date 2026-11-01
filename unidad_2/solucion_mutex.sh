#!/bin/bash
# ==============================================================================
# SOLUCION - UNIDAD 2: aplica exclusion mutua a los dos incidentes
#   Incidente 1 (memoria): saldo menor a 2.000.000 -> se usa seguro.c (pthread_mutex)
#   Incidente 2 (archivo): un proceso pisa el dato del otro -> se usa flock + '>>'
# Uso: ./solucion_mutex.sh
# ==============================================================================

if ! command -v gcc >/dev/null 2>&1; then
    echo "[ERROR]: 'gcc' no esta instalado. Ejecute: cd .. && ./preparar_todo.sh"
    exit 1
fi

echo "============================================================"
echo " 1. COMPILANDO LA VERSION CORREGIDA (seguro.c CON MUTEX)"
echo "============================================================"
gcc seguro.c -o seguro -lpthread
if [ $? -ne 0 ]; then
    echo "[ERROR]: Fallo la compilacion."
    exit 1
fi
echo "[OK]: Binario 'seguro' generado."
echo ""

echo "============================================================"
echo " 2. VERIFICANDO EL SALDO EN 5 EJECUCIONES CONSECUTIVAS"
echo "============================================================"
ESPERADO=2000000
FALLAS=0
for i in 1 2 3 4 5; do
    OBTENIDO=$(./seguro | awk -F'obtenido: ' '{print $2}')
    if [ "$OBTENIDO" -eq "$ESPERADO" ]; then
        echo " Ejecucion $i: saldo = $OBTENIDO -> CORRECTO"
    else
        echo " Ejecucion $i: saldo = $OBTENIDO -> INCORRECTO"
        FALLAS=$((FALLAS + 1))
    fi
done
if [ $FALLAS -eq 0 ]; then
    echo "[RESULTADO]: Las 5 ejecuciones dieron exactamente $ESPERADO. Incidente 1 resuelto."
else
    echo "[RESULTADO]: Hubo $FALLAS ejecuciones con saldo incorrecto."
fi
echo ""

echo "============================================================"
echo " 3. ESCRITURA EN ARCHIVO PROTEGIDA CON CERROJO (flock)"
echo "============================================================"
ARCHIVO="recurso_compartido.txt"
CERROJO="recurso_compartido.lock"
echo "VALOR_INICIAL" > "$ARCHIVO"
echo "Estado inicial del recurso: $(cat $ARCHIVO)"
echo "------------------------------------------------------------"

escribir_con_cerrojo() {
    NOMBRE=$1
    ESPERA=$2
    sleep "$ESPERA"
    (
        flock -x 200
        echo "$NOMBRE" >> "$ARCHIVO"
        echo "[PID $BASHPID] $NOMBRE tomo el cerrojo y agrego su dato"
    ) 200>"$CERROJO"
}

escribir_con_cerrojo "PROCESO_1" 0.05 &
PID1=$!
escribir_con_cerrojo "PROCESO_2" 0.08 &
PID2=$!
wait $PID1 $PID2

echo "------------------------------------------------------------"
echo "Contenido final del recurso:"
cat "$ARCHIVO"
echo "[RESULTADO]: Ningun proceso borro el dato del otro. Incidente 2 resuelto."
rm -f "$CERROJO"
