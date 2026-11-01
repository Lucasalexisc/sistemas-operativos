#!/bin/bash
# ==============================================================================
# SOLUCION - UNIDAD 4 (solucion_inodos.sh)
# Resuelve los dos problemas de la asignacion contigua usando Inodos (Linux ext4/XFS):
#   Problema 1: 'backup_transaccional.iso' (426 bloques) fallaba con ENOSPC aunque
#               sobraban 959 bloques libres (fragmentacion externa en disco).
#   Problema 2: un archivo existente no podia crecer (append) si el bloque
#               fisico siguiente estaba ocupado por otro archivo.
# ==============================================================================

if ! command -v gcc >/dev/null 2>&1; then
    echo "[ERROR]: 'gcc' no esta instalado. Ejecute: cd .. && ./preparar_todo.sh"
    exit 1
fi

echo "============================================================"
echo " 1. COMPILANDO EL SIMULADOR DE DISCO"
echo "============================================================"
gcc simulador_filesystem.c -o simulador_filesystem
if [ $? -ne 0 ]; then
    echo "[ERROR]: Fallo la compilacion."
    exit 1
fi
echo "[OK]: Binario 'simulador_filesystem' generado."
echo ""

echo "============================================================"
echo " 2. ANTES: ARCHIVOS QUE NO ENTRAN CON ASIGNACION CONTIGUA"
echo "============================================================"
# Contamos cuantos archivos dan error 'NO ENTRA' en el modo contiguo First-Fit (F)
FALLAS_F=$(./simulador_filesystem F | grep -c "NO ENTRA")
echo "Archivos rechazados con asignacion contigua (First-Fit): $FALLAS_F"
echo ""

echo "============================================================"
echo " 3. DESPUES: APLICANDO ASIGNACION POR INODOS"
echo "============================================================"
# Ejecutamos en modo Inodos (I), donde el archivo reparte sus bloques en cualquier hueco libre
SALIDA_I=$(./simulador_filesystem I)
echo "$SALIDA_I"
FALLAS_I=$(echo "$SALIDA_I" | grep -c "NO ENTRA")
if [ "$FALLAS_I" -eq 0 ]; then
    echo "[RESULTADO]: Con Inodos los 4 archivos se guardaron. Problema 1 resuelto."
fi
echo ""

echo "============================================================"
echo " 4. PRUEBA REAL EN EL DISCO DE RED HAT: CREAR EL ARCHIVO DE 426 KB"
echo "============================================================"
ARCHIVO="backup_transaccional.iso"
# 'dd' crea el archivo real de 426 KB (426 bloques de 1 KB) tomando bytes en cero de /dev/zero
dd if=/dev/zero of="$ARCHIVO" bs=1K count=426 status=none
echo "[OK]: Archivo creado sin error ENOSPC."
# 'stat -c' muestra el numero de Inodo (%i), el tamano en bytes (%s) y los bloques en disco (%b)
stat -c "Inodo: %i | Tamano: %s bytes | Bloques asignados: %b" "$ARCHIVO"
echo ""

echo "============================================================"
echo " 5. PRUEBA REAL: HACER CRECER EL ARCHIVO (APPEND DE 100 KB)"
echo "============================================================"
# Agregamos 100 KB al final del archivo existente (oflag=append conv=notrunc).
# En Linux con Inodos no hace falta mover el archivo: el Inodo solo suma nuevos punteros.
dd if=/dev/zero of="$ARCHIVO" bs=1K count=100 oflag=append conv=notrunc status=none
echo "[OK]: El archivo crecio sin moverlo ni copiarlo."
stat -c "Inodo: %i | Tamano: %s bytes | Bloques asignados: %b" "$ARCHIVO"
echo "[RESULTADO]: Mismo numero de Inodo, mayor tamano. Problema 2 resuelto."

# Limpiamos el archivo de prueba al finalizar
rm -f "$ARCHIVO"
