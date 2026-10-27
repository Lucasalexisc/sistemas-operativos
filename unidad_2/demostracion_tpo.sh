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

echo "=== DEMOSTRACION CONDICION DE CARRERA - UNIDAD 2 ==="
echo "Compilando programas en C..."

gcc carrera.c -o carrera -lpthread
gcc seguro.c -o seguro -lpthread

if [ $? -ne 0 ]; then
    echo "Error en la compilacion."
    exit 1
fi

echo -e "\n1. Ejecutando programa con condicion de carrera (sin sincronizacion):"
./carrera

echo -e "\n2. Ejecutando programa seguro con pthread_mutex (con exclusion mutua):"
./seguro

echo -e "\n3. Medición de tiempos de ejecucion (impacto del bloqueo/overhead):"
echo "--- Tiempo Sin Mutex ---"
time ./carrera
echo -e "\n--- Tiempo Con Mutex ---"
time ./seguro
