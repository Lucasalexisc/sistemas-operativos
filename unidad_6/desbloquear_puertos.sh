#!/bin/bash
# ==============================================================================
# UNIDAD 6 - RESTAURAR PUERTOS DE RED EN FIREWALL (desbloquear_puertos.sh)
# Vuelve a habilitar el puerto 8080/tcp en la estacion actual, en 'servera' y en
# 'serverb' despues de haber ejecutado la demostracion de bloqueo de la Opcion 1.
# ==============================================================================
PUERTO=8080

echo "--- 1. Desbloqueando puerto $PUERTO/tcp en la maquina actual ---"
# '--add-port' vuelve a abrir el puerto en el firewall local; '--list-ports' confirma la apertura
echo student | sudo -S firewall-cmd --add-port=${PUERTO}/tcp 2>/dev/null
echo "Puertos abiertos localmente: $(echo student | sudo -S firewall-cmd --list-ports 2>/dev/null)"

echo ""
echo "--- 2. Desbloqueando puerto $PUERTO/tcp en 'servera' y 'serverb' ---"
# Nos conectamos por SSH a ambos servidores para dejar el puerto 8080/tcp abierto
ssh student@servera "echo student | sudo -S firewall-cmd --add-port=${PUERTO}/tcp 2>/dev/null; echo student | sudo -S firewall-cmd --list-ports 2>/dev/null"
ssh student@serverb "echo student | sudo -S firewall-cmd --add-port=${PUERTO}/tcp 2>/dev/null; echo student | sudo -S firewall-cmd --list-ports 2>/dev/null"

echo "[OK]: Puertos 8080/tcp desbloqueados en workstation, servera y serverb."
