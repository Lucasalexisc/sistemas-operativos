# 🖥️ Sistemas Operativos (UADE) — Trabajo Práctico Obligatorio (TPO)
> **Entorno de Ejecución:** Red Hat Enterprise Linux (RHEL) — Consola Bash y Lenguaje C (`gcc`).

Este repositorio contiene la resolución práctica, la documentación técnica, los cuestionarios teóricos resueltos y los guiones de defensa oral (*speeches*) para las **6 Unidades** del Trabajo Práctico Obligatorio de **Sistemas Operativos**.

---

## 📁 ¿Cómo está organizado el repositorio?

El repositorio está dividido en **6 carpetas principales** (`unidad_1` a `unidad_6`), más los documentos generales de consignas en la raíz:

```text
sistemas-operativos/
├── DOCUMENTO_FINAL_TPO_UNIDADES_1_A_6.md # Documento único con las 6 unidades para presentar al profesor
├── preparar_todo.sh               # Script integral: permisos (+x) por unidad, auto-reparación de repos e instalación de paquetes
├── menu_tpo.sh                    # Menú interactivo opcional para correr cualquier unidad (1 a 6)
├── .gitignore                     # Ignora binarios compilados para evitar conflictos en git pull
├── Consignas TPO.md / .pdf        # Pautas formales de entrega y defensa del TPO
├── unidad_1/                      # Unidad 1: Introducción a los SO y Llamadas al Sistema (Syscalls)
├── unidad_2/                      # Unidad 2: Procesos, Hilos, Concurrencia y Semáforos (Mutex)
├── unidad_3/                      # Unidad 3: Administración de Memoria y Fragmentación Externa
├── unidad_4/                      # Unidad 4: Sistema de Archivos (Asignación Contigua vs. Inodos)
├── unidad_5/                      # Unidad 5: Entrada/Salida (Transferencia Sin Búfer vs. Con Búfer)
├── unidad_6/                      # Unidad 6: Seguridad (Comprobador de Integridad Hash y ACLs)
└── .agents/skills/                # Skills personalizadas para documentar, resolver cuestionarios y armar speeches
```

Dentro de cada carpeta de unidad vas a encontrar siempre la misma lógica ordenada en **3 partes**:
1. **En la raíz de la unidad (`.c` y `.sh`):** Los programas en C y los scripts en Bash listos para compilar y ejecutar directamente en la terminal de Red Hat.
2. **Carpeta `Documentacion/`:**
   - `DOCUMENTACION_UNIDAD_X.md`: Informe técnico completo de entrega (problema empresarial, marco teórico, código, pruebas y preguntas de examen).
   - `PASO_A_PASO_UNIDAD_X.md`: Guía corta con los comandos exactos para clonar/actualizar el repo y correr el ejercicio en Red Hat.
   - `SPEECH_DEFENSA_UNIDAD_X.md`: Guion hablado paso a paso (2 minutos) con analogías sencillas para exponer oralmente frente al profesor.
3. **Carpeta `Archivos de unidad/`:**
   - Los PDFs teóricos oficiales de la cátedra (`Unidad X.pdf`), las consignas y el **`CUESTIONARIO_RESUELTO_UNIDAD_X.md`** con todas las preguntas teóricas respondidas desde cero.

---

## ⚡ Resumen Rápido de las 6 Unidades (Qué hace cada una)

| Unidad | Tema Central | ¿Qué problema demuestra y resuelve el script? | Comando para correrlo |
| :--- | :--- | :--- | :--- |
| **Unidad 1** | **Syscalls y Kernel** | Un servicio (`sync_service.sh`) falla al querer leer un archivo inexistente y devuelve código de error `101`. El script `audit_syscalls.sh` lo audita con `strace` para interceptar la llamada al sistema `openat` que dio `ENOENT` en el Kernel. | `./audit_syscalls.sh` |
| **Unidad 2** | **Concurrencia y Mutex** | Dos hilos suman `100.000` visitas cada uno a una variable compartida. En `carrera.c` (sin protección) se pisan en la sección crítica y el total da menos de `200.000` (*Condición de Carrera*). En `seguro.c` se soluciona usando un semáforo `pthread_mutex_t` dando siempre `200.000`. | `./demostracion_tpo.sh` |
| **Unidad 3** | **Memoria RAM** | Simula 5 huecos libres en RAM (`100, 500, 200, 300, 600 KB`) y 4 procesos entrantes (`212, 417, 112, 426 KB`). Con **First-Fit (`F`)** el Proceso 4 es rechazado aunque sobran `959 KB` libres (**Fragmentación Externa**). Con **Best-Fit (`B`)** entran los 4 procesos. | `./ejecutar_tpo.sh` |
| **Unidad 4** | **Sistema de Archivos** | Reutiliza el simulador de la Unidad 3 llevado a bloques de disco. Muestra que la **Asignación Contigua (`F`)** falla al guardar el 4to archivo por falta de bloques seguidos, mientras que la **Asignación con Inodos (`I`, como `ext4` en Linux)** reparte los bloques en distintos huecos libres y guarda el 100%. | `./ejecutar_tpo.sh` |
| **Unidad 5** | **Entrada / Salida (Búfer)** | Compara escribir `100.000` letras en un archivo de dos formas: `sin_bufer.c` escribe de a **1 letra por vez** haciendo **100.000 llamadas a `write()`** (lento), mientras que `con_bufer.c` junta bloques de **4.000 letras en un búfer** haciendo **solo 25 llamadas a `write()`** (instantáneo, verificado con `strace -c`). | `./ejecutar_tpo.sh` |
| **Unidad 6** | **Seguridad (Hash y ACL)** | Implementa el **Comprobador de Integridad (`sumacomp`)**: guarda la huella digital SHA-256 de `pagos_empresa.sh` con `sha256sum`. Cuando el archivo está sano permite ejecutarlo; luego simula que un **virus** modifica el archivo, detecta que el Hash cambió (`La suma no coincide`) y **bloquea la ejecución**. | `./ejecutar_tpo.sh` |

---

## 🗂️ Detalle Carpeta por Carpeta

### 🔹 1. `unidad_1/` — Introducción a los Sistemas Operativos
- **Scripts ejecutables:**
  - [`sync_service.sh`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_1/sync_service.sh): Script que intenta abrir `/tmp/os_data_input.txt` y finaliza con `exit 101` si no existe.
  - [`audit_syscalls.sh`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_1/audit_syscalls.sh): Script auditor que ejecuta `strace` sobre el servicio, filtra las llamadas al sistema y explica los anillos de privilegio (Modo Usuario vs. Modo Kernel).
- **Documentación y Teoría:**
  - [`DOCUMENTACION_UNIDAD_1.md`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_1/DOCUMENTACION_UNIDAD_1.md) y `Paso a paso Unidad 1.pdf`.
  - `Archivos de Unidad/`: `Unidad 1.pdf`.

---

### 🔹 2. `unidad_2/` — Procesos, Hilos y Exclusión Mutua
- **Código en C y Scripts ejecutables:**
  - [`carrera.c`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_2/carrera.c): Dos hilos incrementando una variable global sin sincronización (demuestra la **Condición de Carrera**).
  - [`seguro.c`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_2/seguro.c): Solución aplicando **Exclusión Mutua** con `pthread_mutex_lock()` y `pthread_mutex_unlock()`.
  - [`demostracion_tpo.sh`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_2/demostracion_tpo.sh): Compila ambos programas con `gcc -pthread` y compara sus resultados y tiempos con `time`.
  - [`carrera_escritura.sh`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_2/carrera_escritura.sh): Ejemplo complementario en Bash con procesos en segundo plano.
- **Documentación y Teoría:**
  - [`DOCUMENTACION_UNIDAD_2.md`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_2/DOCUMENTACION_UNIDAD_2.md) y `Paso a paso Unidad 2.pdf`.
  - `Archivos de unidad/`: `Unidad 2.pdf` y `Consignas y cuestionario (Unidad 2).pdf`.

---

### 🔹 3. `unidad_3/` — Administración de Memoria
- **Código en C y Script ejecutable:**
  - [`simulador_memoria.c`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_3/simulador_memoria.c): Simulador de asignación de particiones dinámicas en RAM con modos `F` (*First-Fit*) y `B` (*Best-Fit*).
  - [`ejecutar_tpo.sh`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_3/ejecutar_tpo.sh): Compila el simulador, corre ambos algoritmos, mide tiempos y audita la memoria real de Red Hat con `free -h` y `vmstat`.
- **Carpeta `Documentacion/`:**
  - [`DOCUMENTACION_UNIDAD_3.md`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_3/Documentacion/DOCUMENTACION_UNIDAD_3.md) | [`PASO_A_PASO_UNIDAD_3.md`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_3/Documentacion/PASO_A_PASO_UNIDAD_3.md) | [`SPEECH_DEFENSA_UNIDAD_3.md`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_3/Documentacion/SPEECH_DEFENSA_UNIDAD_3.md)
- **Carpeta `Archivos de Unidad/`:**
  - [`CUESTIONARIO_RESUELTO_UNIDAD_3.md`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_3/Archivos%20de%20Unidad/CUESTIONARIO_RESUELTO_UNIDAD_3.md), `Cuestionario Resuelto.pdf`, `Consignas y cuestionario (Unidad 3).pdf` y `Unidad 3.pdf`.

---

### 🔹 4. `unidad_4/` — Sistema de Archivos (File System)
- **Código en C y Script ejecutable:**
  - [`simulador_filesystem.c`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_4/simulador_filesystem.c): Evolución del simulador de la Unidad 3 llevado a disco. Compara la **Asignación Contigua** (`F` y `B`, que sufre fragmentación externa) contra la **Asignación con Inodos (`I`)** propia de Linux `ext4`.
  - [`ejecutar_tpo.sh`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_4/ejecutar_tpo.sh): Compila y corre los 3 modos (`F`, `B`, `I`), e inspecciona un inodo real y su número mágico en Linux con `ls -li`, `stat` y `file`.
- **Carpeta `Documentacion/`:**
  - [`DOCUMENTACION_UNIDAD_4.md`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_4/Documentacion/DOCUMENTACION_UNIDAD_4.md) | [`PASO_A_PASO_UNIDAD_4.md`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_4/Documentacion/PASO_A_PASO_UNIDAD_4.md) | [`SPEECH_DEFENSA_UNIDAD_4.md`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_4/Documentacion/SPEECH_DEFENSA_UNIDAD_4.md)
- **Carpeta `Archivos de unidad/`:**
  - [`CUESTIONARIO_RESUELTO_UNIDAD_4.md`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_4/Archivos%20de%20unidad/CUESTIONARIO_RESUELTO_UNIDAD_4.md), `Cuestionario resuelto.pdf`, `Consignas y cuestionario (Unidad 4).pdf` y `Unidad 4.pdf`.

---

### 🔹 5. `unidad_5/` — Subsistema de Entrada / Salida (E/S)
- **Código en C y Script ejecutable:**
  - [`sin_bufer.c`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_5/sin_bufer.c): Escribe 100.000 letras llamando a `write()` de a **1 byte por vez** (100.000 cambios de contexto al Kernel).
  - [`con_bufer.c`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_5/con_bufer.c): Junta 4.000 letras en un arreglo (`char bufer[4000]`) y escribe en bloque haciendo **solo 25 llamadas a `write()`**.
  - [`ejecutar_tpo.sh`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_5/ejecutar_tpo.sh): Compila ambos programas, compara sus tiempos con `time` y cuenta las llamadas al sistema `write` con `strace -c`.
- **Carpeta `Documentacion/`:**
  - [`DOCUMENTACION_UNIDAD_5.md`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_5/Documentacion/DOCUMENTACION_UNIDAD_5.md) | [`PASO_A_PASO_UNIDAD_5.md`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_5/Documentacion/PASO_A_PASO_UNIDAD_5.md) | [`SPEECH_DEFENSA_UNIDAD_5.md`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_5/Documentacion/SPEECH_DEFENSA_UNIDAD_5.md)
- **Carpeta `Archivos de unidad/`:**
  - [`CUESTIONARIO_RESUELTO_UNIDAD_5.md`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_5/Archivos%20de%20unidad/CUESTIONARIO_RESUELTO_UNIDAD_5.md), `Unidad_5 resuelto.pdf`, `Consignas y cuestionario (Unidad 5).pdf` y `Unidad 5.pdf`.

---

### 🔹 6. `unidad_6/` — Seguridad en Sistemas Operativos (2 Opciones de Laboratorio)
- **Scripts ejecutables:**
  - [`ejecutar_tpo.sh`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_6/ejecutar_tpo.sh): Menú selector que permite correr cualquiera de las 2 opciones preparadas para mostrar al profesor:
  - [`opcion1_servers_remotos.sh`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_6/opcion1_servers_remotos.sh): **Opción 1 (Multi-servidor `servera` y `serverb`):** Prueba conectividad (`ping`), bloquea el puerto `8080/tcp` en el Firewall de `servera` (`firewall-cmd`), lo abre en `serverb`, crea el usuario `auditor` mostrando su **Hash + Salt en `/etc/shadow`** y le da acceso exclusivo con **ACL (`setfacl`/`getfacl`)**.
  - [`opcion2_local_completo.sh`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_6/opcion2_local_completo.sh): **Opción 2 (En un solo servidor):** Ejecuta la demostración de puertos (`ss -tuln`), Firewall (`firewall-cmd`), usuario `auditor` (`/etc/shadow`), permisos **ACL** y el **Comprobador de Integridad Anti-Virus (`sha256sum -c`)** sobre [`pagos_empresa.sh`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_6/pagos_empresa.sh).
- **Carpeta `Documentacion/`:**
  - [`DOCUMENTACION_UNIDAD_6.md`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_6/Documentacion/DOCUMENTACION_UNIDAD_6.md) | [`PASO_A_PASO_UNIDAD_6.md`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_6/Documentacion/PASO_A_PASO_UNIDAD_6.md) | [`SPEECH_DEFENSA_UNIDAD_6.md`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_6/Documentacion/SPEECH_DEFENSA_UNIDAD_6.md)
- **Carpeta `Archivos de unidad/`:**
  - [`CUESTIONARIO_RESUELTO_UNIDAD_6.md`](file:///home/lucas/Escritorio/sistemas-operativos/unidad_6/Archivos%20de%20unidad/CUESTIONARIO_RESUELTO_UNIDAD_6.md), `unidad_6 resuelto.pdf`, `Consignas y cuestionario (Unidad 6).pdf` y `Unidad 6.pdf`.

---

## 🚀 Cómo usar el repositorio en la Consola de Red Hat

1. **Clonar o actualizar el repositorio en Red Hat:**
   ```bash
   # Si es la primera vez:
   git clone https://github.com/Lucasalexisc/sistemas-operativos.git
   cd sistemas-operativos

   # Si ya lo tenías clonado:
   cd ~/sistemas-operativos
   git pull origin main
   ```

2. **Preparar entorno, permisos e instalar dependencias automáticamente:**
   ```bash
   chmod +x preparar_todo.sh menu_tpo.sh
   ./preparar_todo.sh
   ```
   *El script `preparar_todo.sh` se encarga de todo de forma automática:*
   - *Otorga permisos `chmod +x` a los scripts de cada unidad indicando su función.*
   - *Detecta y auto-repara repositorios huérfanos de Red Hat (evitando el error de `repomd.xml` en DNF).*
   - *Verifica e instala con `sudo dnf` todas las herramientas necesarias (`gcc`, `strace`, `acl`, `file`), informando en pantalla para qué unidades sirve cada una.*

3. **Ejecutar cualquier unidad (2 formas a elección):**
   - **Forma A — Entrando a la carpeta de la unidad:**
     ```bash
     cd unidad_X            # Reemplazar por unidad_1, unidad_2, ..., unidad_6
     ./ejecutar_tpo.sh      # (En unidad_1 es ./audit_syscalls.sh y en unidad_2 es ./demostracion_tpo.sh)
     ```
   - **Forma B (Opcional) — Usando el menú rápido desde la raíz:**
     ```bash
     ./menu_tpo.sh          # Abre el menú interactivo para elegir del 1 al 6
     # o directo: ./menu_tpo.sh 4
     ```
