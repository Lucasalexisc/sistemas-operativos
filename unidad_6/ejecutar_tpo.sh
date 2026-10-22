#!/bin/bash
# ==============================================================================
# SCRIPT DE DEMOSTRACION - UNIDAD 6 (SEGURIDAD, INTEGRIDAD HASH Y PERMISOS)
# ==============================================================================

# Validamos que exista el programa de pagos y tenga permisos seguros
if [ ! -f pagos_empresa.sh ]; then
    echo "[ERROR]: No se encontro pagos_empresa.sh"
    exit 1
fi
sed -i '/VIRUS/d' pagos_empresa.sh
chmod 750 pagos_empresa.sh

echo "--- 1. GUARDANDO LA HUELLA DIGITAL (HASH SHA-256) EN 'sumacomp.txt' ---"
sha256sum pagos_empresa.sh > sumacomp.txt
cat sumacomp.txt
echo ""

echo "--- 2. VERIFICANDO ARCHIVO SANO ANTES DE EJECUTAR ---"
if sha256sum -c sumacomp.txt; then
    echo "[OK]: La huella coincide. El archivo es autentico, ejecutando:"
    ./pagos_empresa.sh
fi
echo ""

echo "--- 3. SIMULANDO ATAQUE: UN VIRUS MODIFICA 'pagos_empresa.sh' ---"
echo 'echo "[VIRUS]: Robando contrasenas y desviando fondos..."' >> pagos_empresa.sh
echo "[ALERTA]: Un intruso agrego codigo malicioso dentro de pagos_empresa.sh"
echo ""

echo "--- 4. COMPROBADOR DE INTEGRIDAD DETECTA EL CAMBIO Y BLOQUEA EL VIRUS ---"
if sha256sum -c sumacomp.txt; then
    ./pagos_empresa.sh
else
    echo "[BLOQUEADO]: PELIGRO! El Hash SHA-256 cambio. Ejecucion cancelada!"
fi
echo ""

echo "--- 5. AUDITORIA DE PERMISOS Y ACL EN LINUX (ls -l y getfacl) ---"
ls -l pagos_empresa.sh
getfacl pagos_empresa.sh

# Restauramos el archivo original limpio al terminar
sed -i '/VIRUS/d' pagos_empresa.sh
rm -f sumacomp.txt
