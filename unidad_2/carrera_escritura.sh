#!/bin/bash
# ==============================================================================
# UNIDAD 2 - CONDICION DE CARRERA EN ARCHIVOS (carrera_escritura.sh)
# Demuestra que pasa cuando dos procesos independientes en segundo plano (&)
# escriben sobre un mismo archivo compartido sin bloqueo: el ultimo en escribir
# sobreescribe y destruye el dato que habia guardado el proceso anterior.
# ==============================================================================

# 1. Definimos el archivo que ambos procesos van a compartir y lo inicializamos
ARCHIVO_COMPARTIDO="recurso_compartido.txt"
echo "VALOR_INICIAL" > "$ARCHIVO_COMPARTIDO"

echo "=== DEMOSTRACION: EL ULTIMO QUE ESCRIBE DETERMINA EL VALOR ==="
echo "Estado inicial del recurso: $(cat $ARCHIVO_COMPARTIDO)"
echo "---------------------------------------------------------"

# 2. Proceso 1: simula un tiempo de trabajo (sleep 0.05) y sobreescribe el archivo con '>'
funcion_proceso1() {
    sleep 0.05
    # El operador '>' pisa todo el contenido anterior del archivo
    echo "PROCESO_1" > "$ARCHIVO_COMPARTIDO"
    echo "[PID $BASHPID] Proceso 1 escribio: PROCESO_1"
}

# 3. Proceso 2: tarda un poco mas (sleep 0.08) y tambien sobreescribe el archivo con '>'
funcion_proceso2() {
    sleep 0.08
    echo "PROCESO_2" > "$ARCHIVO_COMPARTIDO"
    echo "[PID $BASHPID] Proceso 2 escribio: PROCESO_2"
}

# 4. Lanzamos ambos procesos AL MISMO TIEMPO en segundo plano usando '&'
#    La variable especial '$!' captura el PID (Process ID) de cada proceso lanzado.
funcion_proceso1 &
PID1=$!

funcion_proceso2 &
PID2=$!

# 5. El comando 'wait' hace que el script espere a que ambos procesos terminen
wait $PID1 $PID2

echo "---------------------------------------------------------"
# 6. Mostramos el contenido final: el dato de PROCESO_1 se perdio porque PROCESO_2 escribio ultimo
echo "Valor final retenido en el recurso: $(cat $ARCHIVO_COMPARTIDO)"
echo "Conclusion: El proceso que escribio ultimo sobreescribio la salida del anterior."
