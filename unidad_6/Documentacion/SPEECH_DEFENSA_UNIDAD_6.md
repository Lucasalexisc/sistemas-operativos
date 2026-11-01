# 🎤 SPEECH DE DEFENSA ORAL — UNIDAD 6: SEGURIDAD EN RED HAT
> **Sistemas Operativos (UADE / Red Hat)** — Guion hablado paso a paso para exponer la Unidad 6 ejecutando el script único `./ejecutar_tpo.sh`.

---

## ⚡ 1. El Problema Explicado en 3 Renglones (Caso Empresarial Simple)

- **La Empresa:** Somos administradores de una red de servidores **Red Hat** (`workstation`, `servera` y `serverb`) de una empresa financiera que ejecuta diariamente el script `pagos_empresa.sh`.
- **El Problema y Objetivo:** Necesitamos aplicar **Defensa en Profundidad** en cuatro capas dentro de una misma demostración:
  1. **Nivel de Red (Firewall):** Bloquear el puerto `8080` en `servera` para que nadie entre, y habilitarlo únicamente en `serverb`.
  2. **Nivel de Autenticación (`/etc/shadow`):** Crear al usuario `auditor` y comprobar cómo Linux guarda su contraseña como **Hash + Salt** y nunca en texto plano.
  3. **Nivel de Permisos (ACL):** Darle permiso de lectura exclusivo al usuario `auditor` sobre un reporte confidencial cerrado (`chmod 600`) usando una **ACL (`setfacl`)**.
  4. **Nivel de Integridad (Hash SHA-256):** Proteger `pagos_empresa.sh` con `sha256sum -c` para que, si un intruso o virus modifica el archivo, el cambio de huella digital bloquee automáticamente su ejecución.

---

## 🎮 2. La Analogía Cotidiana (Para explicarlo en 20 segundos)

> 🗣️ **Cómo contarlo fácil:**
> *"En esta unidad aplicamos **Defensa en Profundidad**, que funciona como las capas de seguridad de un banco:*
> 1. *El **Firewall (`firewall-cmd`)** es el guardia de la entrada: en `servera` tiene la puerta `8080` cerrada con llave y rechaza las conexiones; en `serverb` tiene esa puerta habilitada.*
> 2. *El **Hash con Salt en `/etc/shadow`** y la **ACL (`setfacl`)** son la credencial personal del auditor: aunque el reporte sea privado (`chmod 600`), la lista de control de acceso dice con nombre y apellido que `auditor` tiene permiso para leerlo.*
> 3. *Y el **Hash SHA-256 (`sha256sum`)** es el precinto de seguridad del script de pagos: si un virus agrega una sola línea maliciosa, la huella digital cambia por completo y el sistema cancela su ejecución."*

---

## 🎙️ 3. El Speech Paso a Paso (~2 Minutos)

### Parte 1: Conectividad y Firewall entre `servera` y `serverb` (35 seg)
`[👉 EN CONSOLA: Ejecutar ./ejecutar_tpo.sh]`
```text
--- PRUEBA DE CONEXION AL PUERTO 8080 ---
1) Intentando conectar a servera:8080 (Puerto BLOQUEADO por Firewall):
   [BLOQUEADO]: El Firewall de 'servera' rechazo la conexion al puerto 8080.
2) Intentando conectar a serverb:8080 (Puerto HABILITADO en Firewall):
   [PERMITIDO]: Conexion exitosa con 'serverb' en el puerto 8080.
```
> 🗣️ **Decís:**
> *"Al correr `./ejecutar_tpo.sh`, primero verificamos con `ping` la conexión con `servera` y `serverb` y configuramos el **Firewall (`firewall-cmd`)** por SSH:*
> *- En **`servera`** cerramos el puerto `8080/tcp` (`--remove-port=8080/tcp`), por lo que al intentar conectarnos con `curl` el Firewall bloquea la conexión.*
> *- En **`serverb`** abrimos el puerto `8080/tcp` (`--add-port=8080/tcp`), y comprobamos que la conexión entra correctamente."*

### Parte 2: Usuario `auditor`, Hash+Salt en `/etc/shadow` y ACL (40 seg)
`[👉 EN CONSOLA: Señalar los bloques 2 y 3 de la salida]`
```text
[OK]: Usuario 'auditor' creado. Contrasena guardada como Hash + Salt en /etc/shadow:
auditor:$6$xyz123Salt$8f9a2b...:19651:0:99999:7:::

# file: tmp/reporte_confidencial.txt
user::rw-
user:auditor:r--
group::---
other::---
```
> 🗣️ **Decís:**
> *"En el segundo paso creamos el usuario `auditor` con `useradd` y consultamos `/etc/shadow`: ahí se ve que Linux no guarda la contraseña escrita, sino un **Hash SHA-512 (`$6$`) combinado con un Salt aleatorio** para impedir ataques de diccionario.*
> *En el tercer paso creamos un reporte confidencial con `chmod 600` (donde nadie salvo el dueño tiene acceso) y con `setfacl -m u:auditor:r--` agregamos una **Lista de Control de Acceso (ACL)** que le da permiso de lectura únicamente a `auditor`, sin abrir el archivo al resto de los usuarios."*

### Parte 3: Comprobador de Integridad con `sha256sum` ante un Virus (45 seg)
`[👉 EN CONSOLA: Señalar el bloque 4 del script]`
```text
-> 4.2 Ejecucion normal (verificando la huella antes de correr):
pagos_empresa.sh: La suma coincide
[AUTORIZADO]: La huella coincide. Ejecutando pagos_empresa.sh:
[SISTEMA DE PAGOS]: Transferencia de sueldos realizada con exito.

-> 4.4 LA SOLUCION: El comprobador detecta que el Hash cambio y bloquea la ejecucion:
pagos_empresa.sh: FAILED
[BLOQUEADO]: La huella SHA-256 NO coincide. El archivo fue modificado y su ejecucion se cancelo.
```
> 🗣️ **Decís:**
> *"Por último, en el cuarto paso protegemos el script `pagos_empresa.sh`: primero guardamos su huella digital SHA-256 en `sumacomp.txt` y verificamos con `sha256sum -c` antes de ejecutarlo; como está intacto, coincide y transfiere los sueldos.*
> *Luego simulamos el problema: un intruso le inyecta al final una línea maliciosa con `>>`. Cuando intentamos volver a correrlo, `sha256sum -c` detecta que la huella cambió, devuelve fallo y nuestro bloque `if/else` **bloquea la ejecución** antes de que el virus pueda correr. Al final el propio script limpia la línea maliciosa y deja el entorno restaurado."*

---

## 🛟 4. Salvavidas: Las 5 Preguntas Rápidas del Profe en Vivo

1. **¿Para qué sirve el Firewall (`firewalld`) en Red Hat?**
   - *"Filtra el tráfico de red entrante y saliente según reglas de puertos y servicios, bloqueando cualquier conexión a puertos que no estén explícitamente autorizados, como hicimos en `servera`."*
2. **¿Cómo guarda Linux las contraseñas en `/etc/shadow` y qué es el Salt?**
   - *"Las pasa por una **función de una vía (Hash)** junto con un valor aleatorio llamado **Salt**. El Salt hace que dos usuarios con la misma contraseña tengan hashes distintos y evita que un atacante use diccionarios precalculados."*
3. **¿Qué ventaja tiene una ACL (`setfacl`/`getfacl`) frente al `chmod` común?**
   - *"El `chmod` tradicional solo permite definir permisos para un dueño, un grupo y todos los demás. En cambio la **ACL** permite dar o quitar permisos a usuarios puntuales (como `auditor`) sin abrirle el archivo al resto."*
4. **¿Cuáles son los 4 objetivos de la seguridad?**
   - *"1) **Confidencialidad** (que solo lean los autorizados, como hicimos con la ACL), 2) **Integridad** (que nadie modifique datos sin que se detecte, como hicimos con `sha256sum`), 3) **Disponibilidad** (que el sistema esté operativo) y 4) **Exclusión de usuarios externos** (como hicimos con el Firewall)."*
5. **¿Qué es la Defensa en Profundidad?**
   - *"Es combinar varias capas de seguridad independientes (Firewall de red + Autenticación con Hash/Salt + Permisos/ACL + Comprobador de integridad) para que, si falla una barrera, las demás detengan el ataque."*
