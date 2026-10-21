# 🎤 SPEECH DE DEFENSA ORAL — UNIDAD 4: SISTEMA DE ARCHIVOS
> **Sistemas Operativos (UADE / Red Hat)** — Guion hablado paso a paso, súper simple y con analogías cotidianas (2 minutos).

---

## ⚡ 1. El Problema Explicado en 3 Renglones (Caso Empresarial Simple)

- **La Empresa:** Somos administradores de un servidor **Red Hat** donde los usuarios guardan y borran archivos todo el día.
- **El Problema:** Al borrar archivos viejos, el espacio libre del disco quedó separado en **5 huecos sueltos** (en total suman **1700 bloques libres**). Cuando el servidor intentó guardar un **4to archivo de 426 bloques** usando **Asignación Contigua**, tiró error de **"Disco Lleno"** aunque sobraban **959 bloques libres**, porque ningún hueco suelto tenía 426 bloques todos seguidos.
- **La Solución:** Reutilizamos el código de la Unidad 3 llevado a disco (`simulador_filesystem.c`) y agregamos el **Modo `I` (Inodos de Linux)**, que permite repartir los bloques del archivo en distintos huecos libres sin exigir que estén juntos.

---

## 🎮 2. La Analogía Cotidiana (Para explicarlo en 20 segundos)

> 🗣️ **Cómo contarlo fácil:**
> *"Imagínense que van al cine un grupo de **4 amigos** y en la sala quedan **10 asientos libres**, pero están **todos separados en distintas filas**:*
> - *La **Asignación Contigua** es caprichosa: exige que los 4 amigos se sienten **sí o sí todos juntos en la misma fila**. Como no hay 4 asientos seguidos, **los rebota en la puerta** aunque haya 10 asientos vacíos.*
> - *El **Inodo de Linux (`ext4`)** hace lo lógico: sienta a los 4 amigos en los asientos libres que haya sueltos por la sala y **anota en una tarjetita (el Inodo) en qué butaca se sentó cada uno**. Así entran todos sin desperdiciar lugar."*

---

## 🎙️ 3. El Speech Completo Paso a Paso (~2 Minutos)

### Parte 1: Introducción — El Problema en el Disco (30 seg)
> 🗣️ **Decís:**
> *"En la Unidad 4 reutilizamos la misma base de nuestro programa en C de la Unidad 3, pero llevada al disco duro para explicar cómo guarda los archivos el Sistema de Archivos.*
> *El problema empresarial que simulamos es muy simple: en un servidor se van creando y borrando archivos todo el tiempo, por lo que el espacio libre del disco queda dividido en **5 huecos separados** (`100`, `500`, `200`, `300` y `600` bloques). Queremos guardar **4 archivos**. Si sumamos todo el espacio libre tenemos **1700 bloques**, así que los 4 archivos deberían entrar de sobra."*

### Parte 2: Mostrando el Fallo Contiguo vs. La Solución con Inodos (45 seg)
`[👉 EN CONSOLA: Ejecutar ./ejecutar_tpo.sh y señalar la diferencia entre el punto 2 (Modo F) y el punto 4 (Modo I)]`
```text
--- 2. PRUEBA CON ASIGNACION CONTIGUA (FIRST-FIT) ---
Archivo 1       212 bloques     GUARDADO en Hueco 2 (Contiguo)
Archivo 2       417 bloques     GUARDADO en Hueco 5 (Contiguo)
Archivo 3       112 bloques     GUARDADO en Hueco 2 (Contiguo)
Archivo 4       426 bloques     ERROR: NO ENTRA (Falta espacio contiguo!)
-> Total de espacio libre sobrante en el disco: 959 bloques

--- 4. SOLUCION LINUX: ASIGNACION CON INODOS (EXT4) ---
Archivo 1       212 bloques     GUARDADO (Inodo repartio los bloques en huecos libres)
Archivo 2       417 bloques     GUARDADO (Inodo repartio los bloques en huecos libres)
Archivo 3       112 bloques     GUARDADO (Inodo repartio los bloques en huecos libres)
Archivo 4       426 bloques     GUARDADO (Inodo repartio los bloques en huecos libres)
-> Total de espacio libre sobrante en el disco: 533 bloques
```
> 🗣️ **Decís:**
> *"Cuando corremos `./ejecutar_tpo.sh`, primero probamos la **Asignación Contigua (`Modo F`)**, que exige que cada archivo entre entero de corrido en un solo hueco. Entran los primeros 3 archivos, pero cuando llega el **Archivo 4 de 426 bloques**, tira **`ERROR: NO ENTRA`**, a pesar de que abajo vemos que **sobran 959 bloques libres**. Eso es la **Fragmentación Externa** en el disco: sobra lugar, pero está partido en pedacitos.*
> *Abajo probamos el **`Modo I` (Asignación con Inodos)**, que es como funciona Red Hat Linux con `ext4`. Como el **Inodo** es una fichita con punteros que anota dónde está cada bloque, no necesita que estén juntos: va tomando bloques de los distintos huecos libres hasta completar los 426 bloques, y **guarda los 4 archivos sin errores**."*

### Parte 3: Viendo el Inodo Real en Linux (25 seg)
`[👉 EN CONSOLA: Señalar los pasos 5 y 6 al final del script (ls -li, stat y file)]`
```bash
--- 5. VIENDO UN INODO REAL EN LINUX (ls -li y stat) ---
34218950 -rw-r--r--. 1 lucas lucas 3120 Oct 21 19:00 simulador_filesystem.c

--- 6. VIENDO EL TIPO DE ARCHIVO POR NUMERO MAGICO (file) ---
simulador_filesystem.c: C source, ASCII text
simulador_filesystem:   ELF 64-bit LSB executable...
```
> 🗣️ **Decís:**
> *"Para cerrar, el script ejecuta comandos reales de Red Hat sobre nuestro propio código:
> - Con `ls -li` y `stat` vemos el **número de Inodo real** que Linux le dio a nuestro archivo y cuántos bloques ocupa.
> - Y con `file` demostramos que Linux no mira la extensión del archivo (`.c` o `.exe`), sino que lee su **Número Mágico** en los primeros bytes para saber que uno es texto en C y el otro es un ejecutable binario ELF."*

---

## 💻 4. "Machete" Rápido del Código (Por si el profe te pregunta cómo está hecho `simulador_filesystem.c`)

1. **¿Por qué es igual al de la Unidad 3 pero tiene un modo más?**
   - *Qué responder:* *"Usamos los mismos dos arreglos (`huecos[5]` y `archivos[4]`) para que sea bien fácil de comparar. En los modos `F` y `B` busca un solo hueco donde `huecos[j] >= archivos[i]`. En cambio, en el **Modo `I` (líneas 60 a 72)**, usamos una variable `falta_guardar` que va descontando bloques de cualquier hueco que tenga lugar (`huecos[j] -= usar; falta_guardar -= usar;`) hasta que termina de guardar todo el archivo."*

---

## 🛟 5. Salvavidas: Las 4 Preguntas Rápidas del Profe en Vivo

### ❓ 1. "¿Qué guarda adentro un Inodo y dónde está el nombre del archivo?"
> 🗣️ **Respuesta corta:**
> *"El **Inodo** guarda todos los datos del archivo (quién es el dueño, qué permisos tiene, cuánto pesa, las fechas y las flechas a los bloques del disco), **EXCEPTO el nombre**. El nombre del archivo se guarda en el **Directorio**, que es una tablita con dos columnas: Nombre del archivo y Número de Inodo."*

### ❓ 2. "¿Qué problema tiene la Asignación Contigua si un archivo quiere crecer (agregarle texto al final)?"
> 🗣️ **Respuesta corta:**
> *"Si querés agregar líneas al final de un archivo y el bloque de al lado ya está ocupado por otro archivo, **no puede crecer** (o tenés que mover el archivo entero a otro hueco más grande). Con **Inodos**, en cambio, simplemente agarrás cualquier bloque libre del disco y le agregás una flecha nueva al Inodo."*

### ❓ 3. "¿Cómo sabe Linux qué bloques del disco están libres y cuáles ocupados?"
> 🗣️ **Respuesta corta:**
> *"Con un **Mapa de Bits (Bitmap)**: una fila de ceros y unos donde cada bit representa un bloque del disco (`0` ocupado, `1` libre)."*

### ❓ 4. "¿Qué es el Journaling (Bitácora) en `ext4`?"
> 🗣️ **Respuesta corta:**
> *"Antes de hacer un cambio en el disco, Linux anota en un 'borrador' llamado **Bitácora (Journal)** qué es lo que está por hacer. Si se corta la luz a mitad de camino, cuando prende la PC lee esa bitácora y se recupera en 2 segundos sin tener que escanear todo el disco."*
