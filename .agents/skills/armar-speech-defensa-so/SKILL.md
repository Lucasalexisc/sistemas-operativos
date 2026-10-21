---
name: armar-speech-defensa-so
description: >-
  Genera guiones de exposición oral (speeches) claros, dinámicos y fáciles de memorizar para defender cada unidad del Trabajo Práctico Obligatorio (TPO) de Sistemas Operativos (UADE / Red Hat). Utiliza analogías de videojuegos, aplicaciones cotidianas y situaciones reales para explicar el problema, el código en C/Bash y la teoría del Kernel de forma natural, además de incluir respuestas rápidas a las preguntas de defensa oral del profesor.
---

# Skill: Generador de Speech para Defensa Oral del TPO de Sistemas Operativos

Esta skill define el método y la estructura para armar el **guion hablado (*speech*)** de exposición de cualquiera de las 6 unidades del TPO de **Sistemas Operativos (UADE / Red Hat)**.

El objetivo es que **cualquier integrante del grupo** (incluso si le toca defender al azar según las consignas 5 y 6 del TPO) pueda leer el guion en 5 minutos, entender qué hace el código, ejecutarlo en la consola de Red Hat y explicarlo frente al docente con total naturalidad y solvencia técnica.

---

## 1. Las 5 Reglas de Oro del Speech

1. **Arrancar SIEMPRE desde el Caso Empresarial Hipotético (No asumir contexto previo):**
   - La Consigna 8 del TPO exige que cada ejercicio parta de una situación empresarial imaginaria. El speech **nunca debe arrancar tirando números en el aire** asumiendo que el profesor se acuerda del enunciado: los primeros 20-30 segundos deben presentar brevemente **qué empresa es, qué servicio crítico corría en su servidor Red Hat y cuál fue el incidente/reclamo que disparó todo**.
2. **Escrito para ser hablado (Tono natural, no robótico):**
   - El speech se redacta en **primera persona** (*"En esta unidad nosotros simulamos..."*, *"Acá en la consola podemos ver..."*), usando un lenguaje fluido y natural, como habla un estudiante universitario en un final que **realmente entendió el tema** y no está repitiendo de memoria.
3. **Analogía "Gamer / Consolas de Videojuegos / App Cotidiana" para bajar a tierra el problema:**
   - Inmediatamente después de contar el incidente empresarial, conectar el problema con una analogía de **consolas de videojuegos (PlayStation, Xbox, Nintendo Switch, Steam Deck, Memory Cards)**, **videojuegos conocidos** o **apps de todos los días (Spotify, YouTube, WhatsApp)** antes de meterse en el código.
4. **Guía Escénica + Bloques de Consola Reales ("Qué se ve en la terminal mientras hablás"):**
   - El speech debe indicar entre corchetes `[👉 EN CONSOLA: ...]` qué comando ejecutar y **debe incluir debajo un bloque de consola (` ```text ` o ` ```bash `) con el ejemplo exacto de lo que sale en pantalla**, además de **comandos sueltos de Red Hat** para tirar en vivo si el profesor pide mostrar algo puntual.
5. **Palabras Clave de Aprobación ("Triggers del Profesor"):**
   - Aunque se explique sencillo, cada bloque debe cerrar mencionando los **términos exactos de la cátedra** (Tanenbaum / Silberschatz) que el docente necesita escuchar para poner un 10.

---

## 2. Catálogo de Analogías Sugeridas por Unidad (Juegos, Consolas y Apps)

Al adaptar el speech para una unidad específica, utilizar o combinar estas analogías de **videojuegos, consolas de videojuegos (PS1/PS2/PS5, Xbox, Switch) y programas cotidianos**:

| Unidad | Tema del TPO | Analogía de Juegos / Programas Cotidianos | Analogía de Consolas de Videojuegos (PlayStation / Xbox / Switch) |
| :--- | :--- | :--- | :--- |
| **Unidad 1** | **Syscalls, Modo Kernel vs Usuario y `strace`** | **Anticheat (Vanguard) o "Modo Aventura vs Modo Admin":** Tu personaje (Modo Usuario / Ring 3) no puede tocar el mundo directo; le pide permiso al servidor (Modo Kernel / Ring 0) por comando (**Syscall**). | **El SO de una PS5 o Nintendo Switch:** El juego corre encerrado sin permiso para tocar el hardware directo; cuando quiere leer el joystick o el lector de discos, le hace una **Syscall** al sistema operativo de la consola. |
| **Unidad 2** | **Concurrencia, Condición de Carrera (*Race Condition*) y Mutex** | **Bug de duplicar oro en un MMO o dos jugadores abriendo el mismo cofre en Minecraft** en el mismo milisegundo sin turno (**Race Condition**) vs. ponerle un candado (**Mutex**). | **La Memory Card de la PS1/PS2:** Si dos procesos intentan escribir la misma ranura de partida a la vez sin bloqueo, sale *"Datos Dañados"*. El cartel *"Guardando... No apague la consola ni retire la Memory Card"* es el **Mutex**. |
| **Unidad 3** | **Memoria Contigua, Fragmentación Externa y Paginación** | **El inventario por casilleros del *Resident Evil 4 / Diablo*:** Tenés 10 cuadraditos libres sueltos en las esquinas, pero no te entra un rifle de 4 cuadraditos seguidos (**Fragmentación Externa**). | **Los bloques de una Memory Card clásica o la RAM de la consola:** Si borraste partidas salteadas te quedan bloques libres sueltos, pero un juego que pide 4 bloques seguidos te dice *"Sin espacio"*. La **Paginación** lo parte en bloques de 1x1. |
| **Unidad 4** | **Sistema de Archivos, Asignación Contigua en Disco vs. Inodos (`ext4`)** | **Playlist de Spotify vs. Cuaderno de papel:** En un cuaderno si se te acaban las hojas que dejaste para un tema chocás con el siguiente; en una playlist (**Inodo**) agregás punteros a canciones sueltas. | **CD/Cartucho vs. Disco de PS4/PS5 o Steam Deck:** En un CD viejo todo estaba grabado de corrido (**Contiguo**) porque nunca cambiaba; en el SSD de una PS5 cuando baja un parche de 20 GB que agranda archivos, usa **Inodos** para apuntar a bloques libres sueltos sin reinstalar todo el juego. |
| **Unidad 5** | **Subsistema de E/S, Uso de Búfer (*Buffering*), DMA y Controladores** | **Aldeano del *Age of Empires / Minecraft*:** Llevar **1 sola maderita por viaje** (1 millón de viajes al Kernel sin búfer) vs. llevar una **carretilla de 4 KB** (Con búfer), o la barrita gris de **YouTube**. | **Pantallas de carga de PS3/PS4 (el ascensor del *Mass Effect* o las nubes del *GTA V*) vs. el SSD con DMA de la PS5:** En vez de que la CPU de la consola se trabe pidiendo byte por byte al disco, el controlador **DMA** y los **búferes de bloque** mandan todo directo a la RAM sin frenar la CPU. |
| **Unidad 6** | **Seguridad, Criptografía, Firma de Código, TPM y Defensa en Profundidad** | **Defender tu base en el *Rust / Clash of Clans*:** No ponés una sola puerta; ponés muralla (**Firewall**), torretas (**Antivirus/IDS**) y caja fuerte con clave (**Cifrado/ACL**). | **Por qué una PS5, Xbox o Switch original no corre juegos piratas ni modificados:** Cada juego u actualización trae una **Firma de Código** oficial (clave pública/privada de Sony/Nintendo) y la consola tiene un chip de seguridad (**como el TPM**) con **Secure Boot**. Los viejos "chips" que se soldaban en la PS2 buscaban saltar esa firma. |

---

## 2.1 Catálogo de Ejemplos de Consola Red Hat por Unidad

Cada speech generado debe incluir bloques de salida de consola reales como estos para que el alumno pueda practicar viendo exactamente qué aparece en la terminal y qué comandos sueltos tirar en vivo:

| Unidad | Comando a Ejecutar en Vivo | Ejemplo de Salida en Consola que se debe Explicar |
| :--- | :--- | :--- |
| **Unidad 1** | `./audit_syscalls.sh` o `strace -e trace=openat ./sync_service.sh` | `openat(AT_FDCWD, "/etc/shadow_config.conf", O_RDONLY) = -1 EACCES (Permission denied)` $\to$ Demuestra que el `[ERROR FATAL 101]` era falta de permisos a nivel Kernel. |
| **Unidad 2** | `./demostracion_tpo.sh` o `time ./carrera` vs `time ./seguro` | `Saldo esperado: 2000000 | Saldo final (carrera): 569399` vs `Saldo final (seguro): 2000000` y en `time`: `sys 0m0.002s` (sin mutex) vs `sys 0m1.450s` (con mutex, por la syscall `futex`). |
| **Unidad 3** | `./ejecutar_tpo.sh` o `./simulador_memoria F` y `./simulador_memoria B` | `P4  426 KB  Ninguno  RECHAZADO (Sin espacio contiguo)` con `Memoria total libre no contigua remanente: 959 KB` (First-Fit) vs `P4  426 KB  Hueco 5  ASIGNADO` (Best-Fit). |
| **Unidad 4** | `./ejecutar_tpo.sh`, `stat`, `ls -li`, `df -h`, `df -i`, `file` | `F4 backup_transaccional.iso 426 blk -> FALLO: ENOSPC` (Contiguo) vs `Inodo #1003 (Indexado) -> EXITO: Bloques dispersos` y salida real de `stat` mostrando `Inode: ... IO Block: 4096`. |
| **Unidad 5** | `./ejecutar_tpo.sh`, `strace -c`, `ls -l /dev/zero /dev/sda`, `free -h` | Modo `S` (1 byte): `TOTAL SYSCALLS AL KERNEL: 1048577 | sys 0m0.704s` vs Modo `B` (4096 bytes): `TOTAL SYSCALLS AL KERNEL: 257 | sys 0m0.002s`, y `crw-rw-rw- /dev/zero` vs `brw-rw---- /dev/sda`. |
| **Unidad 6** | `getfacl`, `setfacl`, `sudo grep usuario /etc/shadow`, `sudo firewall-cmd --list-all` | `$6$salt$hash...` en `/etc/shadow` (Hash SHA-512 + Salt), entradas `user:nombre:rw-` en `getfacl` (ACL) y reglas activas en `firewall-cmd`. |

---

## 3. Estructura Estándar del Documento de Speech

Cada vez que el usuario pida generar el speech de una unidad, se debe crear el archivo `unidad_X/SPEECH_DEFENSA_UNIDAD_X.md` (basándose en [plantilla_speech.md](./resources/plantilla_speech.md)) con las siguientes **5 secciones**:

### Sección 1: Ficha Rápida del Caso Empresarial (Para ubicarse en 15 segundos)
- **Empresa y Contexto:** (Quiénes somos y qué servicio corre en Red Hat).
- **El Incidente en Producción:** (Qué falló y por qué se echaban la culpa entre áreas).
- **La Causa Raíz y Solución:** (1 oración resumiendo el diagnóstico y la solución).

### Sección 2: La Analogía para Explicarlo Fácil (Modo Juegos / Apps)
- Explicación de 20 segundos comparando el incidente de la empresa con un juego o programa cotidiano para que cualquiera en el aula lo entienda al instante.

### Sección 3: El Speech Completo Paso a Paso (Duración: ~2 a 2.5 minutos)
Dividido en 4 partes habladas textuales (con comillas, listas para leer o decir):
1. **Introducción: El Caso Empresarial y el Incidente (35 seg):** Presentar desde cero la empresa, qué hacía el servidor Red Hat, qué error saltó en producción y sumarle la analogía cotidiana para que se entienda la paradoja.
2. **Demostración en Consola — Reproduciendo el Fallo (35 seg):** Qué comando ejecutamos (`./ejecutar_tpo.sh`) y qué número o error hay que mirar en pantalla.
3. **La Solución en nuestro Código C/Bash (40 seg):** Qué hace nuestro programa por dentro explicado sin vueltas para resolver el incidente de la empresa.
4. **Cierre Técnico con Comandos de Red Hat (20 seg):** Cómo lo verificamos con las herramientas nativas de Linux (`strace`, `stat`, `time`, `free`, etc.) y conclusión teórica.

### Sección 4: "Machete" del Código (Por si el profesor abre el `.c` o `.sh`)
- Los 3 o 4 bloques clave del código explicados en lenguaje simple: *"Si el profe te señala esta línea, decile esto..."*.

### Sección 5: Salvavidas — Las 5 Preguntas Rápidas que te puede hacer el Profe en Vivo
- Preguntas cortas y al hueso sobre la unidad con respuestas de **2 o 3 oraciones habladas** (fáciles de recordar bajo presión).

---

## 4. Procedimiento cuando el Usuario Pide un Speech

1. **Identificar la unidad solicitada** (Unidad 1 a 6).
2. **Leer los archivos de esa unidad:**
   - El código fuente (`.c` y `.sh`) de la carpeta `unidad_X/`.
   - El documento `DOCUMENTACION_UNIDAD_X.md` y/o `CUESTIONARIO_RESUELTO_UNIDAD_X.md`.
3. **Redactar el speech personalizado** usando los datos, nombres de archivos y números reales que arroja el script de esa unidad (ej. `426 bloques vs 959 libres` en Unidad 3/4, `1.048.577 syscalls vs 257` en Unidad 5, `saldo $2.000.000` en Unidad 2, `ERROR 101 / EACCES` en Unidad 1).
4. **Guardar el archivo** en `unidad_X/SPEECH_DEFENSA_UNIDAD_X.md`.
