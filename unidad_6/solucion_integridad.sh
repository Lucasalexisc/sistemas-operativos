#!/bin/bash
# ==============================================================================
# SOLUCION - UNIDAD 6: LANZADOR SEGURO CON VERIFICACION SHA-256 (solucion_integridad.sh)
#   Problema: un intruso modifica 'pagos_empresa.sh' y el administrador lo ejecuta
#             confiando unicamente en el nombre del archivo.
#   Solucion: 1) restringir permisos del script con chmod 750 (-rwxr-x---)
#             2) registrar la huella SHA-256 oficial del script sano en 'sumacomp.txt'
#             3) ejecutar el script solo a traves de la funcion 'ejecutar_si_es_integro',
#                que verifica 'sha256sum -c' antes de cada corrida y bloquea si cambio.
# ==============================================================================

SCRIPT="pagos_empresa.sh"
HUELLA="sumacomp.txt"

# Funcion lanzadora: valida la integridad criptografica antes de permitir la ejecucion
ejecutar_si_es_integro() {
    # 'sha256sum -c' compara el Hash actual del archivo con el guardado en sumacomp.txt
    if sha256sum -c "$HUELLA"; then
        echo "[AUTORIZADO]: La huella coincide. Se ejecuta el script."
        ./"$SCRIPT"
    else
        echo "[BLOQUEADO]: La huella NO coincide. El archivo fue modificado. Ejecucion cancelada."
    fi
}

echo "============================================================"
echo " 1. DEJANDO EL SCRIPT ORIGINAL CON PERMISOS RESTRINGIDOS (750)"
echo "============================================================"
rm -f "$HUELLA"
# Limpiamos cualquier rastro previo y aplicamos chmod 750 (otros usuarios = 0 permisos)
sed -i '/VIRUS/d' "$SCRIPT"
chmod 750 "$SCRIPT"
ls -l "$SCRIPT"
echo ""

echo "============================================================"
echo " 2. REGISTRANDO LA HUELLA DIGITAL OFICIAL (SHA-256)"
echo "============================================================"
# Calculamos el Hash SHA-256 del script sano y protegemos sumacomp.txt como solo lectura (444)
sha256sum "$SCRIPT" > "$HUELLA"
chmod 444 "$HUELLA"
cat "$HUELLA"
echo ""

echo "============================================================"
echo " 3. EJECUCION NORMAL A TRAVES DEL LANZADOR SEGURO"
echo "============================================================"
ejecutar_si_es_integro
echo ""

echo "============================================================"
echo " 4. SIMULACION DEL ATAQUE: SE AGREGA UNA LINEA MALICIOSA"
echo "============================================================"
# Un intruso agrega codigo malicioso al final de pagos_empresa.sh
echo 'echo "[VIRUS]: Robando contrasenas..."' >> "$SCRIPT"
echo "Ultima linea del archivo ahora: $(tail -n 1 $SCRIPT)"
echo ""

echo "============================================================"
echo " 5. EL LANZADOR SEGURO DETECTA EL CAMBIO Y BLOQUEA"
echo "============================================================"
# Como el contenido cambio, el Hash SHA-256 ya no coincide y el lanzador cancela la ejecucion
ejecutar_si_es_integro
echo ""

echo "============================================================"
echo " 6. RESTAURANDO EL ARCHIVO ORIGINAL Y VERIFICANDO DE NUEVO"
echo "============================================================"
# Quitamos la linea maliciosa con 'sed'; el Hash vuelve a coincidir y el script se ejecuta
sed -i '/VIRUS/d' "$SCRIPT"
ejecutar_si_es_integro

rm -f "$HUELLA"
