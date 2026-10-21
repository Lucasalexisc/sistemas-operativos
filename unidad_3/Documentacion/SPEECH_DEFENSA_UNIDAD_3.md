# 🎤 SPEECH DE DEFENSA ORAL — UNIDAD 3: ADMINISTRACIÓN DE MEMORIA
> **Sistemas Operativos (UADE / Red Hat)** — Guion hablado paso a paso con analogías sencillas para exponer en clase (2 a 3 minutos).

---

## ⚡ 1. Ficha Rápida del Caso Empresarial (Para ubicarse en 15 segundos)

- **La Empresa y el Sistema:** Somos el equipo de Sysadmins de **"Logistics Analytics Corp"**, una empresa de logística que corre en **Red Hat Enterprise Linux** un motor de base de datos en memoria RAM (*in-memory database*) que pide bloques **contiguos** de RAM para alojar tablas de distintos clientes.
- **El Incidente en Producción:** En plena hora pico, el motor rechazó la carga del proceso `P4` (que pedía **426 KB**) tirando error de *"Memoria insuficiente"*, pero cuando mirábamos el servidor con `free -m` sobraban **959 KB libres** (más del doble). Desarrollo decía que el SO reportaba mal la RAM e Infraestructura decía que había una fuga de memoria (*memory leak*).
- **La Causa Raíz y Solución:** Demostramos con un simulador en C que no era un bug ni faltaba RAM, sino **Fragmentación Externa** por usar asignación contigua con **First-Fit**; lo contrastamos con **Best-Fit** y explicamos por qué Red Hat Linux lo resuelve de raíz con **Paginación y Memoria Virtual**.

---

## 🎮 2. La Analogía Cotidiana / Gamer (Para bajar a tierra el problema)

> 🗣️ **Cómo contarlo fácil:**
> *"Lo que le pasó a la empresa es exactamente igual al **inventario por casilleros del Resident Evil 4 o del Diablo** (o querer estacionar en la calle). Imagínense que en la mochila tienen **10 cuadraditos libres en total**, pero están todos separados en las esquinas: 2 arriba, 3 al medio, 2 abajo y 3 al costado. Quieren guardar un ítem grande que ocupa **4 cuadraditos seguidos** y el juego les dice **'No hay espacio'**, aunque les sobre lugar en total. Eso en Sistemas Operativos es la **Fragmentación Externa**."*

---

## 🎙️ 3. El Speech Completo Paso a Paso (~2 Minutos)

### Parte 1: Introducción — El Caso Empresarial y el Incidente (35 seg)
> 🗣️ **Decís:**
> *"En la Unidad 3 abordamos Administración de Memoria a partir de un incidente en una empresa de logística llamada **Logistics Analytics Corp**. Ellos tienen servidores **Red Hat** corriendo un motor de base de datos en memoria que, para trabajar rápido, exige reservar **bloques contiguos (todos seguidos) de memoria RAM** para los procesos de cada cliente.*
> *El problema fue que en hora pico el sistema empezó a rechazar al proceso `P4`, que pedía apenas **426 KB**, tirando error de 'Memoria insuficiente'. Lo raro era que cuando el administrador entraba a la consola de Red Hat y tiraba un `free`, el servidor tenía **959 KB libres**, o sea más del doble de lo que pedía el proceso. Es como en el inventario del Resident Evil cuando tenés muchos casilleros libres sueltos pero no te entra un ítem largo porque ninguno tiene todos los casilleros seguidos."*

### Parte 2: Reproduciendo el Incidente en la Consola de Red Hat — First-Fit (35 seg)
`[👉 EN CONSOLA: Ejecutar ./ejecutar_tpo.sh y señalar el bloque "1. EJECUCION CON PRIMER AJUSTE (FIRST-FIT)"]`
```text
[RESULTADO DE LA ASIGNACION]
Proceso Tamano  Hueco Asignado  Estado
P1      212 KB  Hueco 2         ASIGNADO
P2      417 KB  Hueco 5         ASIGNADO
P3      112 KB  Hueco 2         ASIGNADO
P4      426 KB  Ninguno         RECHAZADO (Sin espacio contiguo)

[ESTADO FINAL DE LOS HUECOS LIBRES]
Hueco 1: 100 KB | Hueco 2: 176 KB | Hueco 3: 200 KB | Hueco 4: 300 KB | Hueco 5: 183 KB
Memoria total libre no contigua remanente: 959 KB
```
> 🗣️ **Decís:**
> *"Acá cuando corremos `./ejecutar_tpo.sh`, primero se ejecuta nuestro simulador en C con el algoritmo **First-Fit (Primer Ajuste)**. ¿Qué hace First-Fit? Mete a cada proceso en el **primer hueco** donde entra:
> - Al proceso 1 (212 KB) lo mete en el Hueco 2 (que era de 500 KB), partiéndolo al medio.
> - Al proceso 2 (417 KB) lo mete en el Hueco 5 (de 600 KB).
> - Al proceso 3 (112 KB) lo mete también en lo que sobraba del Hueco 2.
> ¿Qué pasa cuando llega `P4` pidiendo **426 KB**? Como ven acá en pantalla, dice **RECHAZADO**. Nos quedaron **959 KB libres en total**, pero repartidos en 5 pedacitos (el más grande es de 300 KB). Como la asignación es **contigua**, no podemos partir el proceso y falla por **Fragmentación Externa**."*

### Parte 3: Cómo lo Resuelve nuestro Código en C — Best-Fit (40 seg)
`[👉 EN CONSOLA: Señalar el bloque "2. EJECUCION CON MEJOR AJUSTE (BEST-FIT)"]`
```text
[RESULTADO DE LA ASIGNACION]
Proceso Tamano  Hueco Asignado  Estado
P1      212 KB  Hueco 4         ASIGNADO
P2      417 KB  Hueco 2         ASIGNADO
P3      112 KB  Hueco 3         ASIGNADO
P4      426 KB  Hueco 5         ASIGNADO
Memoria total libre no contigua remanente: 533 KB
```
> 🗣️ **Decís:**
> *"Abajo nuestro script corre el mismo escenario pero cambiando el algoritmo a **Best-Fit (Mejor Ajuste)** (`./simulador_memoria B`). En vez de agarrar el primer hueco que encuentra, Best-Fit revisa los 5 huecos y elige **el hueco donde el proceso entra más justito**, para no desperdiciar los huecos grandes:
> - Entonces mete a `P1` (212 KB) en el hueco de 300 KB, y así **guarda intacto el hueco de 600 KB**.
> - Cuando finalmente llega `P4` (426 KB), el hueco de 600 KB sigue libre y **los 4 procesos se asignan con éxito**."*

### Parte 4: Medición con `time` y Cierre Teórico de Linux (20 seg)
`[👉 EN CONSOLA: Señalar el bloque "3. ANALISIS COMPARATIVO DE TIEMPOS DE EJECUCION" o tirar free -h / cat /proc/meminfo]`
```bash
$ time ./simulador_memoria F > /dev/null
real    0m0.002s   user    0m0.001s   sys     0m0.001s
$ free -h
              total        used        free      shared  buff/cache   available
Mem:          3.8Gi       1.1Gi       1.5Gi        24Mi       1.2Gi       2.4Gi
```
> 🗣️ **Decís:**
> *"Por último, en el script medimos el tiempo con `time`. Aunque Best-Fit logró meter los 4 procesos, en la teoría tiene dos desventajas: es más lento porque tiene que recorrer toda la lista de huecos, y suele dejar huequitos minúsculos inservibles. Por eso **Red Hat Linux moderno no usa asignación contigua para los procesos**, sino **Paginación y Memoria Virtual**: divide la RAM en **marcos de 4 KB** y los procesos en **páginas de 4 KB**, y con la **MMU** y la **Tabla de Páginas** los guarda en cualquier hueco libre sin necesitar que estén seguidos, eliminando al 100% la fragmentación externa."*

---

## 💻 4. "Machete" Rápido del Código (Por si el profe te pide abrir `simulador_memoria.c`)

1. **Si te pregunta cómo representamos la memoria y los procesos (líneas 20–22):**
   - *Qué responder:* *"Usamos dos arreglos de enteros en C: `huecos[5] = {100, 500, 200, 300, 600}` para los bloques libres de RAM y `procesos[4] = {212, 417, 112, 426}` para lo que pide cada proceso."*
2. **Si te pregunta cuál es la diferencia en el código entre First-Fit y Best-Fit (líneas 59–84):**
   - *Qué responder:* *"En **First-Fit** (línea 65) apenas encontramos un hueco donde `huecos[j] >= procesos[i]`, hacemos un `break` y cortamos la búsqueda. En cambio, en **Best-Fit** (líneas 71–78) no hay `break`: recorremos los 5 huecos comparando `huecos[j] < huecos[mejor_idx]` para quedarnos con el más chico donde quepa."*
3. **Si te pregunta por qué en el `.sh` hacemos `time ./simulador_memoria F > /dev/null`:**
   - *Qué responder:* *"Mandamos la salida de texto a `/dev/null` para medir con `time` únicamente lo que tarda el algoritmo en la CPU, sin que nos ensucie la medición el tiempo de imprimir letras en la pantalla."*

---

## 🛟 5. Salvavidas: Las 5 Preguntas Rápidas del Profe en Vivo

### ❓ 1. "¿Qué diferencia hay entre Fragmentación Externa y Fragmentación Interna?"
> 🗣️ **Respuesta corta:**
> *"La **Fragmentación Externa** es el espacio que queda **afuera** de las particiones, repartido en huecos sueltos entre procesos, por lo que no podés meter un proceso grande aunque la suma te alcance (pasa en asignación contigua y segmentación). La **Fragmentación Interna** es el pedacito que sobra **adentro** de un bloque o página de tamaño fijo: por ejemplo, si las páginas son de 4 KB y tu proceso usa 3 KB, ese 1 KB que sobra adentro de la página asignada es fragmentación interna."*

### ❓ 2. "Si Best-Fit pudo meter los 4 procesos, ¿significa que Best-Fit siempre es mejor que First-Fit?"
> 🗣️ **Respuesta corta:**
> *"No. En este ejemplo puntual ganó porque salvó el hueco de 600 KB, pero en general **First-Fit suele ser más rápido** (porque corta en el primer hueco que sirve) y **Best-Fit tiende a llenar la memoria de micro-huecos diminutos** e inútiles porque siempre busca dejar el menor sobrante posible."*

### ❓ 3. "¿Cómo se soluciona la fragmentación externa si estamos obligados a usar asignación contigua?"
> 🗣️ **Respuesta corta:**
> *"Mediante la **Compactación**: el sistema operativo frena todo y corre los procesos hacia un extremo de la memoria para juntar todos los huecos libres en un solo bloque grande (como desfragmentar). El problema es que **es carísimo en tiempo de CPU** mover todo en la RAM."*

### ❓ 4. "¿Qué hacen la MMU y el TLB cuando Linux usa Paginación?"
> 🗣️ **Respuesta corta:**
> *"El programa trabaja con **direcciones lógicas (o virtuales)** pensando que su memoria es toda seguida. La **MMU (Unidad de Gestión de Memoria)** es el chip de hardware que traduce en el acto cada dirección virtual (número de página + desplazamiento) a la **dirección física** real en la RAM (número de marco + desplazamiento) mirando la Tabla de Páginas. Y como mirar la Tabla de Páginas en RAM en cada instrucción sería lento, la MMU tiene una memoria caché ultrarrápida adentro llamada **TLB** que guarda las últimas traducciones."*

### ❓ 5. "¿Qué es un Fallo de Página (*Page Fault*) y qué es la Hiperpaginación (*Thrashing*)?"
> 🗣️ **Respuesta corta:**
> *"Un **Fallo de Página** pasa cuando el programa quiere usar una página que no está cargada en la RAM (su bit de validez está en 0); eso dispara una trampa (*trap*) al sistema operativo para que la busque en el disco (Swap) y la suba a un marco libre. Y el **Thrashing (Hiperpaginación)** es cuando un proceso tiene tan pocos marcos de RAM asignados que se la pasa fallando y trayendo páginas del disco todo el tiempo: el disco queda al 100% y la CPU no avanza nada (como cuando abrís 50 pestañas de Chrome con 4 GB de RAM)."*
