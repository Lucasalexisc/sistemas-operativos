#!/bin/bash
# ==============================================================================
# UNIDAD 2 - DEMOSTRACION DE CONDICION DE CARRERA VS MUTEX (demostracion_tpo.sh)
# Compila y compara dos programas multi-hilo en C (8 hilos x 250.000 depositos):
#   1) carrera.c : sin sincronizacion (pierde depositos por condicion de carrera)
#   2) seguro.c  : con exclusion mutua pthread_mutex (da siempre 2.000.000 exactos)
# ==============================================================================

# 0. Verificamos que el compilador de C (gcc) este instalado en Red Hat
if ! command -v gcc >/dev/null 2>&1; then
    echo "============================================================"
    echo " [ERROR]: 'gcc' no esta instalado en este sistema Red Hat."
    echo " Para instalarlo automaticamente junto a las demas herramientas:"
    echo "   cd .. && ./preparar_todo.sh"
    echo " O manualmente: sudo dnf install -y --disablerepo='*ansible*' gcc"
    echo "============================================================"
    exit 1
fi

echo "=== DEMOSTRACION CONDICION DE CARRERA - UNIDAD 2 ==="
echo "Compilando programas en C..."

# 1. Compilamos ambos programas vinculando la libreria POSIX Threads (-lpthread)
#    que es obligatoria en Linux para crear hilos y usar cerrojos Mutex.
gcc carrera.c -o carrera -lpthread
gcc seguro.c -o seguro -lpthread

# $? guarda el codigo de retorno del ultimo comando; si es distinto de 0 (-ne 0) hubo error
if [ $? -ne 0 ]; then
    echo "Error en la compilacion."
    exit 1
fi

# 2. Ejecutamos el programa sin proteccion: los 8 hilos se pisan al hacer 'contador++'
echo -e "\n1. Ejecutando programa con condicion de carrera (sin sincronizacion):"
./carrera

# 3. Ejecutamos el programa con Mutex: solo 1 hilo a la vez entra a la seccion critica
echo -e "\n2. Ejecutando programa seguro con pthread_mutex (con exclusion mutua):"
./seguro

# 4. Medimos el impacto en tiempos de CPU con el comando 'time':
#    - real: tiempo total de reloj
#    - user: tiempo de CPU en Modo Usuario
#    - sys : tiempo de CPU en Modo Kernel (aumenta con Mutex por la syscall 'futex')
echo -e "\n3. Medicion de tiempos de ejecucion (impacto del bloqueo/overhead):"
echo "--- Tiempo Sin Mutex ---"
time ./carrera
echo -e "\n--- Tiempo Con Mutex ---"
time ./seguro
