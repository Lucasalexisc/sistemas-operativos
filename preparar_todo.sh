#!/bin/bash
# ==============================================================================
# PREPARADOR DE ENTORNO - SISTEMAS OPERATIVOS (UADE / RED HAT)
# Otorga permisos de ejecucion a todos los scripts (.sh) de las 6 unidades
# y valida las herramientas necesarias en Red Hat.
# ==============================================================================

echo "=================================================================="
echo " 1. OTORGANDO PERMISOS DE EJECUCION (+x) A TODOS LOS SCRIPTS (.sh)"
echo "=================================================================="
chmod +x *.sh unidad_*/*.sh 2>/dev/null
chmod 750 unidad_6/pagos_empresa.sh 2>/dev/null
echo "[OK]: Todos los scripts (.sh) de las Unidades 1 a 6 tienen permisos listos."
echo "      (Nota: Los archivos .c no necesitan chmod +x porque los compila gcc)."
echo ""

echo "=================================================================="
echo " 2. VERIFICANDO HERRAMIENTAS EN RED HAT (gcc, strace, sha256sum)"
echo "=================================================================="
for cmd in gcc strace sha256sum getfacl; do
    if command -v $cmd >/dev/null 2>&1; then
        echo "  [OK]: '$cmd' esta instalado."
    else
        echo "  [AVISO]: '$cmd' NO esta instalado (en Red Hat: sudo dnf install -y $cmd)."
    fi
done
echo ""
echo "[LISTO]: Entorno preparado. Podes entrar a cada unidad o correr ./menu_tpo.sh"
