#!/bin/bash
# ==============================================================================
# SOLUCION - UNIDAD 6: lanzador seguro para 'pagos_empresa.sh'
#   Problema: un intruso modifica pagos_empresa.sh y el administrador lo ejecuta
#             confiando solo en el nombre del archivo.
#   Solucion: 1) restringir permisos (chmod 750)
#             2) registrar la huella SHA-256 oficial del script
#             3) verificar la huella ANTES de cada ejecucion y bloquear si cambio
# Uso: ./solucion_integridad.sh
# ==============================================================================

SCRIPT="pagos_empresa.sh"
HUELLA="sumacomp.txt"

ejecutar_si_es_integro() {
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
sed -i '/VIRUS/d' "$SCRIPT"
chmod 750 "$SCRIPT"
ls -l "$SCRIPT"
echo ""

echo "============================================================"
echo " 2. REGISTRANDO LA HUELLA DIGITAL OFICIAL (SHA-256)"
echo "============================================================"
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
echo 'echo "[VIRUS]: Robando contrasenas..."' >> "$SCRIPT"
echo "Ultima linea del archivo ahora: $(tail -n 1 $SCRIPT)"
echo ""

echo "============================================================"
echo " 5. EL LANZADOR SEGURO DETECTA EL CAMBIO Y BLOQUEA"
echo "============================================================"
ejecutar_si_es_integro
echo ""

echo "============================================================"
echo " 6. RESTAURANDO EL ARCHIVO ORIGINAL Y VERIFICANDO DE NUEVO"
echo "============================================================"
sed -i '/VIRUS/d' "$SCRIPT"
ejecutar_si_es_integro

rm -f "$HUELLA"
