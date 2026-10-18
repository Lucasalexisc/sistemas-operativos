#!/bin/bash

ARCHIVO_COMPARTIDO="recurso_compartido.txt"

# Limpiar o inicializar el recurso
echo "VALOR_INICIAL" > "$ARCHIVO_COMPARTIDO"

echo "=== DEMOSTRACION: EL ULTIMO QUE ESCRIBE DETERMINA EL VALOR ==="
echo "Estado inicial del recurso: $(cat $ARCHIVO_COMPARTIDO)"
echo "---------------------------------------------------------"

# Proceso 1: Simula un proceso que procesa y escribe "DATO_PROCESO_1"
funcion_proceso1() {
    # Simula latencia o ráfaga de CPU variable
    sleep 0.05
    echo "PROCESO_1" > "$ARCHIVO_COMPARTIDO"
    echo "[PID $$] Proceso 1 escribio: PROCESO_1"
}

# Proceso 2: Simula un proceso competidor que escribe "DATO_PROCESO_2"
funcion_proceso2() {
    # Simula latencia o ráfaga de CPU variable
    sleep 0.08
    echo "PROCESO_2" > "$ARCHIVO_COMPARTIDO"
    echo "[PID $$] Proceso 2 escribio: PROCESO_2"
}

# Lanzamiento concurrente en segundo plano (&)
funcion_proceso1 &
PID1=$!

funcion_proceso2 &
PID2=$!

# Esperar a que ambos procesos terminen (sincronización a nivel de script)
wait $PID1 $PID2

echo "---------------------------------------------------------"
echo "Valor final retenido en el recurso: $(cat $ARCHIVO_COMPARTIDO)"
echo "Conclusion: El proceso que escribio ultimo sobreescribio la salida del anterior."