#!/bin/bash
# ==============================================================================
# UNIDAD 4 - DEMOSTRACION DE SISTEMA DE ARCHIVOS E INODOS (ejecutar_tpo.sh)
# Compila 'simulador_filesystem.c' y compara como se guardan 4 archivos en disco:
#   - Modo F (Contiguo First-Fit): el Archivo 4 (426 bloques) falla con ENOSPC.
#   - Modo B (Contiguo Best-Fit) : entran al elegir el hueco mas justo.
#   - Modo I (Inodos Linux ext4) : reparte los bloques en cualquier hueco libre.
# Ademas inspecciona un inodo real con 'ls -li', 'stat' y numeros magicos con 'file'.
# ==============================================================================

# 0. Verificamos que el compilador 'gcc' este instalado
if ! command -v gcc >/dev/null 2>&1; then
    echo "============================================================"
    echo " [ERROR]: 'gcc' no esta instalado en este sistema Red Hat."
    echo " Para instalarlo automaticamente junto a las demas herramientas:"
    echo "   cd .. && ./preparar_todo.sh"
    echo " O manualmente: sudo dnf install -y --disablerepo='*ansible*' gcc"
    echo "============================================================"
    exit 1
fi

echo "--- 1. COMPILANDO EL SIMULADOR DE DISCO ---"
gcc simulador_filesystem.c -o simulador_filesystem
if [ $? -ne 0 ]; then
    echo "[ERROR]: Fallo la compilacion."
    exit 1
fi
echo "[OK]: Compilado correctamente."
echo ""

echo "--- 2. PRUEBA CON ASIGNACION CONTIGUA (FIRST-FIT) ---"
# Parametro F: exige que todo el archivo entre de corrido en el primer hueco libre
./simulador_filesystem F
echo ""

echo "--- 3. PRUEBA CON ASIGNACION CONTIGUA (BEST-FIT) ---"
# Parametro B: exige bloques contiguos pero busca el hueco mas ajustado
./simulador_filesystem B
echo ""

echo "--- 4. SOLUCION LINUX: ASIGNACION CON INODOS (EXT4) ---"
# Parametro I: simula Inodos de Linux; fragmenta el archivo en bloques y usa todos los huecos
./simulador_filesystem I
echo ""

echo "--- 5. VIENDO UN INODO REAL EN LINUX (ls -li y stat) ---"
# 'ls -li': la opcion '-i' muestra en la primera columna el numero unico de Inodo del archivo
ls -li simulador_filesystem.c
echo ""
# 'stat': muestra todos los metadatos guardados dentro del Inodo (tamano, bloques, permisos, fechas)
stat simulador_filesystem.c
echo ""

echo "--- 6. VIENDO EL TIPO DE ARCHIVO POR NUMERO MAGICO (file) ---"
# 'file' lee los primeros bytes (Numero Magico) para distinguir texto ASCII de un binario ELF
file simulador_filesystem.c
file simulador_filesystem
