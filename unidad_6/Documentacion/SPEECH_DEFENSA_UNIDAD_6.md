# 🎤 SPEECH DE DEFENSA ORAL — UNIDAD 6: SEGURIDAD
> **Sistemas Operativos (UADE / Red Hat)** — Guion hablado paso a paso, súper simple y con analogías cotidianas (2 minutos).

---

## ⚡ 1. El Problema Explicado en 3 Renglones (Caso Empresarial Simple)

- **La Empresa:** Somos administradores de un servidor **Red Hat** donde todos los días corre el programa `pagos_empresa.sh` para pagar los sueldos.
- **El Problema:** Un **virus o intruso activo** logró meterse y agregarle una línea maliciosa adentro a `pagos_empresa.sh` para robar claves y desviar plata, dejándole el mismo nombre de archivo para que nadie sospeche.
- **La Solución:** Armamos el **Comprobador de Integridad (`sumacomp`)** que explica la cátedra en la Unidad 6: antes de ejecutar el programa, le controlamos su **huella digital (Hash SHA-256)** con `sha256sum -c`. Si alguien le tocó una sola letra, el hash no coincide y **el servidor bloquea la ejecución automáticamente**.

---

## 🎮 2. La Analogía Cotidiana / Consola (Para explicarlo en 20 segundos)

> 🗣️ **Cómo contarlo fácil:**
> *"Un **Hash (Función de una vía)** y un **Comprobador de Integridad** funcionan igual que el **precinto de seguridad de un frasco de mermelada o de un medicamento**:*
> - *Cuando sale de fábrica tiene su huella digital original (`sumacomp.txt`).*
> - *Si alguien abre el frasco y le mete algo adentro (un virus), la tapa hace 'pop' y la huella cambia por completo. Aunque el frasco por fuera tenga la misma etiqueta, te das cuenta al instante de que fue adulterado y no lo consumís.*
> *Es exactamente lo que hace una **PlayStation 5 o Nintendo Switch** antes de abrir un juego descargado: le calcula el Hash, lo compara contra la firma oficial, y si alguien modificó un solo byte del juego para piratearlo o meter un truco, la consola tira error y **no lo deja arrancar**."*

---

## 🎙️ 3. El Speech Completo Paso a Paso (~2 Minutos)

### Parte 1: Introducción — Qué hicimos en la Unidad 6 (30 seg)
> 🗣️ **Decís:**
> *"En la Unidad 6 trabajamos sobre Seguridad, y para que sea igual de claro y directo que en la Unidad 1, armamos dos scripts cortitos en Bash basados en el **Comprobador de Integridad (`sumacomp`)** del apunte de la materia.*
> *Tenemos el programa oficial de la empresa, `pagos_empresa.sh`, que transfiere los sueldos. El peligro que queremos evitar es la **pérdida de Integridad**: que un intruso activo o un virus modifique nuestro archivo agregándole código malicioso sin cambiarle el nombre."*

### Parte 2: Mostrando el Archivo Sano vs. El Ataque Bloqueado en Consola (45 seg)
`[👉 EN CONSOLA: Ejecutar ./ejecutar_tpo.sh y señalar los pasos 1, 2, 3 y 4]`
```text
--- 1. GUARDANDO LA HUELLA DIGITAL (HASH SHA-256) EN 'sumacomp.txt' ---
925a7589db645f416f6fb34761f5add25b6fc5cb5c06668a26af16b0d3417270  pagos_empresa.sh

--- 2. VERIFICANDO ARCHIVO SANO ANTES DE EJECUTAR ---
pagos_empresa.sh: La suma coincide
[OK]: La huella coincide. El archivo es autentico, ejecutando:
[SISTEMA DE PAGOS]: Conectando con el banco...
[SISTEMA DE PAGOS]: Transferencia de sueldos realizada con exito.

--- 3. SIMULANDO ATAQUE: UN VIRUS MODIFICA 'pagos_empresa.sh' ---
[ALERTA]: Un intruso agrego codigo malicioso dentro de pagos_empresa.sh

--- 4. COMPROBADOR DE INTEGRIDAD DETECTA EL CAMBIO Y BLOQUEA EL VIRUS ---
pagos_empresa.sh: La suma no coincide
sha256sum: ATENCIÓN: 1 suma calculada NO coincidió
[BLOQUEADO]: PELIGRO! El Hash SHA-256 cambio. Ejecucion cancelada!
```
> 🗣️ **Decís:**
> *"Cuando corremos `./ejecutar_tpo.sh`, pasan 4 cosas muy fáciles de seguir:
> 1. Primero le calculamos la huella digital a `pagos_empresa.sh` usando la **función de una vía `sha256sum`** y la guardamos en `sumacomp.txt`.
> 2. En el paso 2, antes de ejecutarlo, tiramos `sha256sum -c sumacomp.txt`. Como el archivo está limpio, Linux dice **`La suma coincide`** y el programa de pagos se ejecuta con éxito.
> 3. En el paso 3 simulamos el ataque: un virus se mete y le agrega una línea al final de `pagos_empresa.sh` para robar contraseñas.
> 4. En el paso 4 nuestro script vuelve a verificar la integridad antes de correrlo: `sha256sum -c` detecta inmediatamente que **`La suma no coincide`** porque al cambiar el archivo cambió su hash, y **bloquea la ejecución** salvando al servidor."*

### Parte 3: Permisos y ACL en Linux (15 seg)
`[👉 EN CONSOLA: Señalar el paso 5 al final de la salida (ls -l y getfacl)]`
```text
--- 5. AUDITORIA DE PERMISOS Y ACL EN LINUX (ls -l y getfacl) ---
-rwxr-x--- 1 lucas lucas 197 oct 21 19:52 pagos_empresa.sh
# file: pagos_empresa.sh
user::rwx
group::r-x
other::---
```
> 🗣️ **Decís:**
> *"Y en el paso 5 mostramos la prevención con **Permisos y Listas de Control de Acceso (`getfacl`)**: con `chmod 750` dejamos que solo el dueño tenga permiso de escritura (`rwx`), el grupo solo lectura/ejecución (`r-x`) y los demás usuarios nada (`---`), aplicando **Defensa en Profundidad**."*

---

## 💻 4. "Machete" Rápido del Script (Por si el profe te pregunta qué hace una línea de `ejecutar_tpo.sh`)

1. **¿Qué hace `sha256sum pagos_empresa.sh > sumacomp.txt` (línea 15)?**
   - *Qué responder:* *"Calcula el resumen criptográfico (Hash de 256 bits) del archivo y lo guarda en un archivo de texto llamado `sumacomp.txt`."*
2. **¿Qué hace `if sha256sum -c sumacomp.txt; then` (líneas 20 y 31)?**
   - *Qué responder:* *"La opción `-c` (*check*) vuelve a calcular el hash actual del archivo y lo compara contra el que estaba guardado en `sumacomp.txt`. Si son iguales devuelve verdadero y entra al `if` para ejecutar el programa; si alguien modificó el archivo, devuelve error y salta al `else` bloqueando la ejecución."*

---

## 🛟 5. Salvavidas: Las 5 Preguntas Rápidas del Profe en Vivo

### ❓ 1. "¿Cuáles son los 4 objetivos de la seguridad y cuál protegimos acá?"
> 🗣️ **Respuesta corta:**
> *"Los 4 objetivos son:
> 1) **Confidencialidad** (que nadie no autorizado lea datos secretos).
> 2) **Integridad** (que nadie modifique datos ni programas sin permiso — **es lo que protegimos hoy con el Hash**).
> 3) **Disponibilidad** (que nadie tire abajo el servidor con un ataque DoS).
> 4) **Exclusión de usuarios externos** (que ningún virus convierta la máquina en zombie)."*

### ❓ 2. "¿Qué es una Función de Una Vía (Hash) y para qué más la usa Linux además de verificar archivos?"
> 🗣️ **Respuesta corta:**
> *"Es una cuenta matemática que es muy fácil de calcular para adelante, pero **imposible de volver para atrás** (con viendo el hash no podés adivinar el texto original). Además de verificar la integridad de archivos como hicimos hoy, Linux la usa para **guardar las contraseñas en `/etc/shadow`** junto con un número aleatorio llamado **Salt**."*

### ❓ 3. "¿Qué es el 'Salt' en las contraseñas de Linux y para qué sirve?"
> 🗣️ **Respuesta corta:**
> *"Es un número aleatorio que Linux le pega a tu contraseña antes de calcularle el Hash. Sirve para que, si dos usuarios eligen la misma contraseña (por ejemplo `'Perro'`), sus hashes guardados sean totalmente distintos, y así un hacker no pueda usar un **diccionario precalculado** para adivinarlas."*

### ❓ 4. "¿Qué diferencia hay entre Criptografía Simétrica (Clave Secreta) y Asimétrica (Clave Pública)?"
> 🗣️ **Respuesta corta:**
> *"La **Simétrica** usa **la misma llave** para cerrar (cifrar) y para abrir (descifrar); es rapidísima pero es difícil pasarse la llave sin que te la roben. La **Asimétrica** usa **dos llaves distintas**: una **Clave Pública** que conoce todo el mundo y una **Clave Privada** secreta que solo tiene el dueño (es la que se usa para hacer **Firmas Digitales** y **Firma de Código**)."*

### ❓ 5. "¿Para qué sirve una ACL (Lista de Control de Acceso)?"
> 🗣️ **Respuesta corta:**
> *"Es una lista pegada a cada archivo que dice exactamente qué usuarios o grupos tienen permiso para leerlo, escribirlo o ejecutarlo (`getfacl` / `setfacl`), permitiendo darle o sacarle permiso a una persona puntual sin cambiarle los permisos a todo el resto."*
