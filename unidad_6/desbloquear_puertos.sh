#!/bin/bash
# ==============================================================================
# SCRIPT PARA DESBLOQUEAR / RESTAURAR PUERTOS EN RED HAT (UNIDAD 6)
# ==============================================================================
PUERTO=8080

echo "--- 1. Desbloqueando puerto $PUERTO/tcp en la maquina actual ---"
echo student | sudo -S firewall-cmd --add-port=${PUERTO}/tcp 2>/dev/null
echo "Puertos abiertos localmente: $(echo student | sudo -S firewall-cmd --list-ports 2>/dev/null)"

echo ""
echo "--- 2. Desbloqueando puerto $PUERTO/tcp en 'servera' y 'serverb' ---"
ssh student@servera "echo student | sudo -S firewall-cmd --add-port=${PUERTO}/tcp 2>/dev/null; echo student | sudo -S firewall-cmd --list-ports 2>/dev/null"
ssh student@serverb "echo student | sudo -S firewall-cmd --add-port=${PUERTO}/tcp 2>/dev/null; echo student | sudo -S firewall-cmd --list-ports 2>/dev/null"

echo "[OK]: Puertos 8080/tcp desbloqueados en workstation, servera y serverb."
