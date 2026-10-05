#!/bin/bash
echo "============================================================"
echo " 1. CICLO DE TRADUCCION PASO A PASO (UNIDAD 3)"
echo "============================================================"
echo "[+] Fase 0: Preprocesamiento (gcc -E -> auditoria.i)"
gcc -E auditoria.c -o auditoria.i
echo "    Lineas de auditoria.c: $(wc -l < auditoria.c) | Lineas de auditoria.i: $(wc -l < auditoria.i)"

echo "[+] Fase 1: Compilacion a Assembler (gcc -S -> auditoria.s)"
gcc -S auditoria.i -o auditoria.s
echo "    Instrucciones generadas en Assembler:"
grep -E "pushq|movq|call" auditoria.s | head -n 4

echo "[+] Fase 2: Ensamblado a Codigo Objeto (gcc -c)"
gcc -c auditoria.s -o auditoria.o
gcc -c -fPIC modulo.c -o modulo.o
file auditoria.o modulo.o

echo ""
echo "============================================================"
echo " 2. GENERACION DE BIBLIOTECAS: ESTATICA (.a) VS COMPARTIDA (.so)"
echo "============================================================"
# Crear biblioteca estatica (.a)
ar rcs libmodulo.a modulo.o
echo "[+] Biblioteca estatica creada: libmodulo.a"

# Crear biblioteca dinamica compartida (.so)
gcc -shared -o libmodulo.so modulo.o
echo "[+] Biblioteca compartida dinamica creada: libmodulo.so"

echo ""
echo "============================================================"
echo " 3. ENLACE Y COMPARACION EN DISCO / MEMORIA"
echo "============================================================"
# Enlace estatico incorporando libmodulo.a
gcc auditoria.o libmodulo.a -o binario_estatico

# Enlace dinamico referenciando libmodulo.so
gcc auditoria.o -L. -lmodulo -Wl,-rpath,. -o binario_dinamico

echo "[+] Comparacion de archivos generados (ls -lh):"
ls -lh binario_estatico binario_dinamico libmodulo.so libmodulo.a

echo ""
echo "============================================================"
echo " 4. AUDITORIA DE DEPENDENCIAS Y CARGA DINAMICA EN RAM"
echo "============================================================"
echo "[+] Dependencias dinamicas (ldd binario_dinamico):"
ldd ./binario_dinamico

echo ""
echo "[+] Ejecucion del binario dinamico con syscalls (strace):"
strace -e openat ./binario_dinamico
