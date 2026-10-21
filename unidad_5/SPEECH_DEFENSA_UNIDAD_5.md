# 🎤 SPEECH DE DEFENSA ORAL — UNIDAD 5: ENTRADA / SALIDA (E/S)
> **Sistemas Operativos (UADE / Red Hat)** — Guion hablado paso a paso, súper simple y con analogías cotidianas (2 minutos).

---

## ⚡ 1. El Problema Explicado en 3 Renglones (Caso Empresarial Simple)

- **La Empresa:** Somos administradores de un servidor **Red Hat** que guarda registros (*logs*) en un archivo de texto.
- **El Problema:** El servidor andaba lentísimo y con la CPU al 100% al guardar apenas **100.000 letras**. Cuando lo auditamos con `strace` (igual que en la Unidad 1), vimos que el programa estaba escribiendo **de a 1 letra por vez (`sin_bufer.c`)**, haciendo **100.000 llamadas al sistema `write()`**.
- **La Solución:** Hicimos un segundo programa (`con_bufer.c`) que junta **4.000 letras en un Búfer en memoria** antes de llamar a `write()`, bajando de **100.000 viajes al Kernel a solo 25 viajes**.

---

## 🎮 2. La Analogía Cotidiana / Consola (Para explicarlo en 20 segundos)

> 🗣️ **Cómo contarlo fácil:**
> *"Imagínense que tienen que llevar **100 productos** desde la góndola del supermercado hasta la caja:*
> - *Hacer E/S **Sin Búfer (`sin_bufer.c`)** es agarrar **1 solo producto con la mano**, caminar hasta la caja, volver a la góndola a buscar otro, y así hacer **100 viajes caminando**.*
> - *Hacer E/S **Con Búfer (`con_bufer.c`)** es usar el **carrito del supermercado**: metés todo adentro del carrito y hacés **un solo viaje hasta la caja**.*
> *Es lo mismo que pasa cuando guardás la partida en una consola **PlayStation**: el juego no frena para escribir letra por letra en el disco SSD, sino que arma el bloque entero en un **búfer en memoria RAM** y lo manda todo junto de un solo golpe."*

---

## 🎙️ 3. El Speech Completo Paso a Paso (~2 Minutos)

### Parte 1: Introducción — Qué comparamos en la Unidad 5 (30 seg)
> 🗣️ **Decís:**
> *"En la Unidad 5 estudiamos el subsistema de Entrada/Salida y por qué el **Uso de Búfer** es fundamental en Linux. Para demostrarlo de la forma más simple posible —igual que hicimos en la Unidad 2 con `carrera.c` y `seguro.c`—, armamos dos programitas en C de 20 líneas que hacen exactamente el mismo trabajo: **escribir 100.000 letras `'A'` en un archivo**.*
> - *El primero, `sin_bufer.c`, tiene un bucle `for` de 100.000 vueltas que llama a `write(fd, "A", 1)` para escribir **1 letra por vez**.*
> - *El segundo, `con_bufer.c`, junta **4.000 letras** adentro de un arreglo `char bufer[4000]` y hace un `for` de **solo 25 vueltas** llamando a `write(fd, bufer, 4000)`."*

### Parte 2: Mostrando `time` y `strace -c` en Consola (45 seg)
`[👉 EN CONSOLA: Ejecutar ./ejecutar_tpo.sh y señalar primero los tiempos con 'time' y abajo la tabla de 'strace -c']`
```text
--- 2. EJECUCION LENTA: SIN BUFER (100.000 viajes al Kernel) ---
[SIN BUFER]: Escribiendo 100.000 letras de a 1 byte por vez...
real    0m0.210s   |   sys    0m0.195s

--- 3. EJECUCION RAPIDA: CON BUFER (Solo 25 viajes al Kernel) ---
[CON BUFER]: Escribiendo 100.000 letras en bloques de 4000 bytes...
real    0m0.001s   |   sys    0m0.001s

--- 4. CONTANDO LAS LLAMADAS AL SISTEMA 'write' CON STRACE ---
-> Cantidad de syscalls SIN BUFER:
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
100.00    0.184000           1    100000           write

-> Cantidad de syscalls CON BUFER:
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
100.00    0.000050           2        25           write
```
> 🗣️ **Decís:**
> *"Cuando ejecutamos `./ejecutar_tpo.sh`, primero medimos el tiempo de ambos con el comando `time`: vemos que `sin_bufer` tarda cientos de milisegundos con el tiempo `sys` (Modo Kernel) altísimo, mientras que `con_bufer` tarda **1 milisegundo**.*
> *¿Por qué hay tanta diferencia si los dos escriben las mismas 100.000 letras? Abajo lo probamos usando `strace -c`, la misma herramienta de la Unidad 1:
> - En `sin_bufer`, la columna `calls` muestra **`100000` llamadas a `write`**. Cada vez que se llama a `write`, la CPU tiene que frenar, pasar de Modo Usuario a Modo Kernel y volver.
> - En `con_bufer`, la columna `calls` muestra **solo `25` llamadas a `write`** (`25 x 4000 = 100.000`). Ahorramos **99.975 viajes al Kernel** gracias al búfer."*

---

## 💻 4. "Machete" Rápido del Código (Por si el profe te pide abrir `sin_bufer.c` o `con_bufer.c`)

1. **¿Qué diferencia hay en el código entre los dos archivos?**
   - *Qué responder:* *"En `sin_bufer.c` (línea 12) hacemos `for (int i = 0; i < 100000; i++) write(fd, "A", 1);`. En cambio en `con_bufer.c` (línea 10) declaramos `char bufer[4000];`, lo llenamos con `memset` y hacemos `for (int i = 0; i < 25; i++) write(fd, bufer, 4000);`."*
2. **¿Por qué usamos `write()` y no `printf()` o `fprintf()`?**
   - *Qué responder:* *"Porque `printf` y `fwrite` son funciones de la librería estándar de C (`stdio.h`) que ya traen un búfer oculto adentro. Usando la llamada al sistema directa `write()` le hablamos directo al Kernel y podemos ver la diferencia real entre usar o no usar búfer."*

---

## 🛟 5. Salvavidas: Las 4 Preguntas Rápidas del Profe en Vivo

### ❓ 1. "¿Qué diferencia hay entre un Dispositivo de Bloque y un Dispositivo de Carácter?"
> 🗣️ **Respuesta corta:**
> *"Un **Dispositivo de Bloque** guarda información en casilleros de tamaño fijo (bloques) con dirección propia, por lo que podés saltar a leer cualquier parte (como un disco duro o pendrive). Un **Dispositivo de Carácter** manda o recibe un chorro de bytes uno tras otro sin bloques ni direcciones (como el teclado, el mouse o una impresora)."*

### ❓ 2. "¿Cuáles son las 3 formas en que la CPU puede hacer Entrada/Salida y cuál es la mejor?"
> 🗣️ **Respuesta corta:**
> *"1) **E/S Programada (Polling):** la CPU se queda preguntándole todo el tiempo al dispositivo '¿ya terminaste?', desperdiciando el 100% del procesador.
> 2) **E/S por Interrupciones:** la CPU le da la orden al dispositivo y se va a hacer otra cosa; el dispositivo le toca el timbre (interrupción) cuando termina, pero interrumpe una vez por cada byte.
> 3) **DMA (Acceso Directo a Memoria):** es la mejor. Un chip especial copia el bloque entero del disco a la RAM sin molestar a la CPU, y recién le manda **una sola interrupción cuando terminó de copiar todo el bloque**."*

### ❓ 3. "¿Cuáles son las 4 capas del software de E/S?"
> 🗣️ **Respuesta corta:**
> *"De arriba hacia abajo son:
> 1) **Espacio de Usuario** (las librerías de C y el Spooling).
> 2) **Software Independiente del Dispositivo** (donde viven los búferes y el tamaño de bloque uniforme que probamos hoy).
> 3) **Drivers de Dispositivos** (el código que sabe hablar con una marca y modelo de placa en particular).
> 4) **Manejadores de Interrupciones** (los que atienden el aviso eléctrico del hardware abajo de todo)."*

### ❓ 4. "¿Qué es el Spooling (por ejemplo en una impresora)?"
> 🗣️ **Respuesta corta:**
> *"Como una impresora no puede imprimir un renglón tuyo y un renglón mío mezclados al mismo tiempo, ningún programa habla directo con la impresora. Los programas mandan su archivo a una carpeta de espera en el disco (**directorio de Spool**), y un solo proceso administrador (**demonio**) los va imprimiendo de a uno en fila."*
