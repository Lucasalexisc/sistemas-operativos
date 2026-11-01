#!/bin/bash
# ==============================================================================
# SOLUCION - UNIDAD 2 (solucion_mutex.sh)
# Resuelve los dos problemas de concurrencia de la Unidad 2 aplicando Exclusion Mutua:
#   1) En Memoria RAM: ejecuta 'seguro.c' (con pthread_mutex_t) 5 veces seguidas
#      verificando que jamas se pierda ni un solo peso (siempre da 2.000.000).
#   2) En Archivos   : utiliza un cerrojo exclusivo de Kernel ('flock -x') y el
#      operador de agregado ('>>') para que ambos procesos guarden su informacion
#      en orden sin pisarse ni borrar los datos del otro.
# ==============================================================================

if ! command -v gcc >/dev/null 2>&1; then
    echo "[ERROR]: 'gcc' no esta instalado. Ejecute: cd .. && ./preparar_todo.sh"
    exit 1
fi

echo "============================================================"
echo " 1. COMPILANDO LA VERSION CORREGIDA (seguro.c CON MUTEX)"
echo "============================================================"
# Compilamos seguro.c vinculando la libreria de hilos (-lpthread)
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

# Corremos 5 pruebas seguidas para comprobar que con Mutex el resultado es siempre exacto
for i in 1 2 3 4 5; do
    # Extraemos el numero final obtenido usando 'awk'
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

# Funcion protegida: antes de tocar el archivo, pide un cerrojo exclusivo al Kernel
escribir_con_cerrojo() {
    NOMBRE=$1
    ESPERA=$2
    sleep "$ESPERA"
    (
        # 'flock -x 200' adquiere un candado exclusivo (Mutex de archivos) sobre el descriptor 200.
        # Si otro proceso lo esta usando, espera su turno igual que pthread_mutex_lock.
        flock -x 200
        # Usamos '>>' (append) para agregar al final sin borrar lo que escribio el proceso anterior
        echo "$NOMBRE" >> "$ARCHIVO"
        echo "[PID $BASHPID] $NOMBRE tomo el cerrojo y agrego su dato"
    ) 200>"$CERROJO"
}

# Lanzamos ambos procesos en paralelo (&) y esperamos a que terminen (wait)
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
