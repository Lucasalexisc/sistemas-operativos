#!/bin/bash
echo "============================================================"
echo " 1. CICLO DE TRADUCCION PASO A PASO (UNIDAD 3)"
echo "============================================================"
echo "[+] Fase 0: Preprocesamiento (gcc -E -> auditoria.i)"
gcc -E auditoria.c -o auditoria.i
echo "    Lineas de auditoria.c: $(wc -l < auditoria.c) | Lineas de auditoria.i: $(wc -l < auditoria.i)"

echo "[+] Fase 1: Compilacion a Assembler (gcc -S -> auditoria.s)"
gcc -S auditoria.i -o auditoria.s
echo "    Primeras instrucciones de CPU generadas:"
head -n 12 auditoria.s

echo "[+] Fase 2: Ensamblado a Codigo Objeto (gcc -c -> auditoria.o)"
gcc -c auditoria.s -o auditoria.o
file auditoria.o

echo "[+] Fase 3: Enlace Dinamico - Modulo de Carga (gcc -> auditoria_dinamico)"
gcc auditoria.o -o auditoria_dinamico
./auditoria_dinamico

echo ""
echo "============================================================"
echo " 2. ENLACE ESTATICO VS. ENLACE DINAMICO (IMPACTO EN MEMORIA)"
echo "============================================================"
echo "[+] Compilando modulo de carga estatico..."
gcc -static auditoria.c -o auditoria_estatico

echo "[+] Comparacion de peso fisico en disco (ls -lh):"
ls -lh auditoria_dinamico auditoria_estatico

echo ""
echo "============================================================"
echo " 3. INSPECCION DE DEPENDENCIAS Y CARGA DINAMICA"
echo "============================================================"
echo "[+] Dependencias dinamicas del ejecutable (ldd):"
ldd ./auditoria_dinamico

echo ""
echo "[+] Syscalls del cargador para mapear la biblioteca compartida (strace):"
strace -e openat ./auditoria_dinamico
