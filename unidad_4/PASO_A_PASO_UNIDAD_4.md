# GUÍA PASO A PASO: EJECUCIÓN UNIDAD 4 EN RED HAT ENTERPRISE LINUX (RHEL)
## SISTEMA DE ARCHIVOS — ASIGNACIÓN CONTIGUA VS. NODOS-I (INODES)

Esta guía sencilla contiene los comandos exactos para sincronizar el repositorio desde GitHub (`Lucasalexisc/sistemas-operativos`) y ejecutar el ejercicio en la consola de Red Hat.

---

## 1. Subir los archivos actuales a GitHub (Desde tu PC donde estás editando)

Para que los nuevos archivos de la Unidad 4 estén disponibles en GitHub y puedas bajarlos en Red Hat:

```bash
# 1. Pararse en la raíz del repositorio local
cd "c:\Users\lucas\OneDrive\Escritorio\UADE\2026\Segundo cuatrimestre\3. Sistemas operativos\Segundo parcial\TPO\sistemas-operativos"

# 2. Agregar los archivos de la unidad 4
git add unidad_4/

# 3. Guardar el commit
git commit -m "Entrega Unidad 4: Documentacion, simulador filesystem en C y script de ejecucion"

# 4. Subir a GitHub
git push origin main
```

---

## 2. Traer el Repositorio en la Consola de Red Hat

Abrí la terminal de Red Hat Enterprise Linux. Dependiendo de tu situación, ejecutá la opción A o B:

### Opción A: Si es la primera vez que vas a clonar el repo en Red Hat
```bash
# 1. Ir a tu carpeta personal (home)
cd ~

# 2. Clonar el repositorio desde GitHub
git clone https://github.com/Lucasalexisc/sistemas-operativos.git

# 3. Entrar a la carpeta de la Unidad 4
cd sistemas-operativos/unidad_4
```

### Opción B: Si ya tenías clonado el repositorio previamente en Red Hat
```bash
# 1. Entrar a la carpeta del repositorio
cd ~/sistemas-operativos

# 2. Descargar los últimos cambios subidos
git pull origin main

# 3. Entrar a la carpeta de la Unidad 4
cd unidad_4
```

---

## 3. Ejecutar el Script en Red Hat

Una vez ubicado dentro de `unidad_4`:

```bash
# 1. Otorgar permisos de ejecución al script
chmod +x ejecutar_tpo.sh

# 2. Ejecutar el script orquestador
./ejecutar_tpo.sh
```

---

## 4. ¿Qué hace y qué muestra el programa en pantalla?

El script ejecuta automáticamente los siguientes 6 pasos:

1. **Compilación automática en C:**  
   Compila `simulador_filesystem.c` usando `gcc -Wall -O2` generando el binario ejecutable `simulador_filesystem`.
2. **Ejecución 1 (Modo `F` - Asignación Contigua First-Fit):**  
   Muestra el incidente corporativo: el archivo `backup_transaccional.iso` (426 bloques) es **RECHAZADO con error ENOSPC (No space left on device)** a pesar de que el disco tiene **959 bloques libres totales**, evidenciando empíricamente la **Fragmentación Externa en Disco**.
3. **Ejecución 2 (Modo `B` - Asignación Contigua Best-Fit):**  
   Acomoda los archivos en los huecos más justos, pero se explica por qué falla ante el crecimiento dinámico de archivos (*append*) si los bloques continuos siguientes están ocupados.
4. **Ejecución 3 (Modo `I` - Asignación Indexada con Nodos-i / Inodes de ext4):**  
   Muestra la solución moderna de Red Hat Linux: el Inodo recolecta bloques libres dispersos (176 del hueco 2, 183 del hueco 5 y 67 del hueco 4) logrando almacenar el **100% de los archivos sin compactar el disco**.
5. **Comparativa de Tiempos (`time`):**  
   Mide los microsegundos de CPU de cada algoritmo.
6. **Auditoría Forense con Comandos Nativos de Red Hat:**  
   Crea un archivo temporal con `dd` y audita en vivo:
   - `stat`: muestra el número de inodo, bloques reales y tamaño de bloque de E/S (`IO Block: 4096`).
   - `ls -li`: muestra el número de inodo en el directorio.
   - `df -h` y `df -i`: muestra el espacio en disco vs. la cantidad de inodos disponibles.
   - `file`: verifica el número mágico y formato del archivo.

---

## 5. Resumen para la Defensa Oral Individual (1 a 2 Minutos)

Si el docente te convoca individualmente para defender la Unidad 4, explicás estos 3 puntos:

1. **El Problema (30 segundos):**  
   *"En nuestro servidor Red Hat simulamos un almacenamiento que utilizaba asignación contigua de archivos para maximizar lecturas continuas. Debido al borrado de archivos temporales, el disco sufrió fragmentación externa: al intentar guardar un backup de 426 bloques, el sistema arrojó error de falta de espacio (`ENOSPC`) a pesar de que `df` mostraba 959 bloques libres en total."*
2. **La Solución Práctica (45 segundos):**  
   *"Demostramos con el simulador que el algoritmo de asignación contigua fracasa porque ningún hueco individual alcanza los 426 bloques. Luego activamos el modo de Asignación Indexada con Nodos-i (el esquema real de ext4 en Red Hat): el inodo mapea bloques dispersos en el mapa de bits y guardó el 100% del archivo sin necesidad de desfragmentar ni compactar el disco."*
3. **El Remate Teórico (Preguntas clave de cátedra):**  
   - **¿Qué es la fragmentación externa en disco?** Es cuando la suma total de espacio libre es suficiente para un archivo, pero no se puede guardar porque los bloques libres están dispersos y el esquema exige bloques contiguos.
   - **¿Cómo lo soluciona Red Hat?** Con la **Asignación Indexada mediante Nodos-i (Inodes)**: cada archivo tiene una estructura propia con punteros directos e indirectos a cualquier bloque del disco, eliminando la necesidad de contigüidad y permitiendo que los archivos crezcan dinámicamente.
