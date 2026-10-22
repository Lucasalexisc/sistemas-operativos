# 🎤 SPEECH DE DEFENSA ORAL — UNIDAD 6: SEGURIDAD EN RED HAT
> **Sistemas Operativos (UADE / Red Hat)** — Guion hablado paso a paso para cualquiera de las 2 opciones (`opcion1_servers_remotos.sh` o `opcion2_local_completo.sh`).

---

## ⚡ 1. El Problema Explicado en 3 Renglones (Caso Empresarial Simple)

- **La Empresa:** Somos administradores de una red de servidores **Red Hat** (`workstation`, `servera` y `serverb`).
- **El Problema:** Necesitamos aplicar **Defensa en Profundidad** en tres niveles:
  1. **Nivel de Red (Firewall):** Bloquear el puerto `8080` en `servera` para que nadie entre, y habilitarlo únicamente en `serverb`.
  2. **Nivel de Usuarios y Acceso (Autenticación y ACL):** Crear un usuario autorizado (`auditor`), ver cómo Linux protege su clave con **Hash + Salt en `/etc/shadow`**, y darle permiso exclusivo sobre un archivo confidencial usando una **ACL (`setfacl`)**.
  3. **Nivel de Integridad de Archivos (Hash SHA-256):** Verificar con `sha256sum -c` que el script `pagos_empresa.sh` no haya sido modificado por un virus antes de ejecutarlo.

---

## 🎮 2. La Analogía Cotidiana / Consola (Para explicarlo en 20 segundos)

> 🗣️ **Cómo contarlo fácil:**
> *"En esta unidad aplicamos **Defensa en Profundidad**, que es como la seguridad de un edificio corporativo o de una consola **PlayStation 5**:*
> 1. *El **Firewall (`firewall-cmd`)** es el guardia de la puerta de calle: en `servera` tiene la puerta `8080` cerrada con llave y rebota a cualquiera que quiera entrar; en `serverb` tiene esa puerta habilitada.*
> 2. *El **Usuario y la ACL (`useradd` + `setfacl`)** es la tarjeta magnética personal: aunque un archivo sea privado (`chmod 600`), la ACL dice con nombre y apellido que el usuario `auditor` tiene permiso para leerlo.*
> 3. *Y el **Hash (`sha256sum`)** es el precinto de seguridad: si un virus modifica una sola línea de un programa, su huella digital cambia y el servidor bloquea su ejecución."*

---

## 🎙️ 3. El Speech Paso a Paso (~2 Minutos)

### Parte 1: Conectividad y Firewall entre `servera` y `serverb` (40 seg)
`[👉 EN CONSOLA: Ejecutar ./ejecutar_tpo.sh y elegir Opción 1 (o Opción 2 si estás en un solo server)]`
```text
--- PRUEBA DE CONEXION DESDE AFUERA AL PUERTO 8080 ---
1) Intentando conectar a servera:8080 (Puerto BLOQUEADO por Firewall):
   [BLOQUEADO]: El Firewall de 'servera' rechazo la conexion al puerto 8080!
2) Intentando conectar a serverb:8080 (Puerto HABILITADO en Firewall):
   [PERMITIDO]: Conexion exitosa con 'serverb' en el puerto 8080!
```
> 🗣️ **Decís:**
> *"Primero verificamos con `ping` cómo se conectan nuestros servidores en Red Hat y configuramos el **Firewall (`firewall-cmd`)**:
> - A **`servera`** le bloqueamos el puerto `8080/tcp` (`firewall-cmd --remove-port=8080/tcp`), entonces cuando intentamos conectarnos desde afuera, **el Firewall nos bloquea la entrada**.
> - A **`serverb`** en cambio le abrimos el puerto `8080/tcp` (`firewall-cmd --add-port=8080/tcp`), y vemos cómo la conexión pasa sin problemas."*

### Parte 2: Creación del Usuario `auditor`, Hash+Salt en `/etc/shadow` y ACL (40 seg)
`[👉 EN CONSOLA: Señalar los pasos de useradd, /etc/shadow y getfacl]`
```text
[OK]: Usuario 'auditor' creado.
-> Viendo su contrasena cifrada con Hash + Salt aleatorio en /etc/shadow:
auditor:$6$xyz123Salt$8f9a2b...:19651:0:99999:7:::

# file: tmp/reporte_confidencial.txt
user::rw-
user:auditor:r--
group::---
other::---
```
> 🗣️ **Decís:**
> *"Segundo, creamos el usuario autorizado `auditor` con `useradd` y mostramos su línea real en `/etc/shadow`: ahí se ve que Linux nunca guarda la contraseña en texto plano, sino que usa una **función de una vía (Hash SHA-512, `$6$`)** mezclada con un **Salt aleatorio** para evitar ataques de diccionario.*
> *Tercero, creamos un archivo secreto con permiso `600` (cerrado para todos) y usando una **Lista de Control de Acceso (`setfacl -m u:auditor:r--`)** le damos permiso de lectura **únicamente al usuario `auditor`**, comprobando con `getfacl` y `su - auditor` que él sí puede leerlo."*

### Parte 3: Comprobador de Integridad Anti-Virus con `sha256sum` (30 seg)
`[👉 EN CONSOLA: Si corriste la Opción 2, señalar el paso 4 del Comprobador de Integridad]`
```text
-> 4.2 Verificamos antes de ejecutar:
pagos_empresa.sh: La suma coincide
[SISTEMA DE PAGOS]: Transferencia de sueldos realizada con exito.

-> 4.4 El Comprobador de Integridad detecta que el Hash cambio y bloquea:
pagos_empresa.sh: La suma no coincide
[BLOQUEADO]: PELIGRO! El Hash SHA-256 no coincide. Ejecucion cancelada!
```
> 🗣️ **Decís:**
> *"Y como cierre, mostramos el **Comprobador de Integridad (`sumacomp`)**: le sacamos el Hash SHA-256 a nuestro script `pagos_empresa.sh`. Mientras nadie lo toque, `sha256sum -c` dice **`La suma coincide`** y lo ejecuta; pero apenas simulamos que un virus le inyecta una línea adentro, el Hash cambia, dice **`La suma no coincide`** y cancela la ejecución."*

---

## 🛟 4. Salvavidas: Las 5 Preguntas Rápidas del Profe en Vivo

1. **¿Para qué sirve el Firewall (`firewalld`) en Red Hat?**
   - *"Filtra el tráfico de red que entra y sale del servidor según reglas de puertos, servicios o direcciones IP, bloqueando cualquier conexión a puertos que no estén explícitamente autorizados."*
2. **¿Cómo guarda Linux las contraseñas en `/etc/shadow` y qué es el Salt?**
   - *"Las pasa por una **función de una vía (Hash)** junto con un texto aleatorio llamado **Salt**. El Salt sirve para que dos usuarios con la misma contraseña tengan hashes distintos y un atacante no pueda usar un diccionario precalculado."*
3. **¿Qué ventaja tiene una ACL (`setfacl`/`getfacl`) frente al `chmod` común?**
   - *"El `chmod` común solo te deja definir permisos para 1 dueño, 1 grupo y 'todos los demás'. En cambio la **ACL** te deja agregar una lista con usuarios puntuales (como nuestro usuario `auditor`) sin abrirle el archivo al resto."*
4. **¿Cuáles son los 4 objetivos de la seguridad?**
   - *"1) **Confidencialidad** (que solo lean los autorizados, como hicimos con la ACL), 2) **Integridad** (que nadie modifique datos sin permiso, como controlamos con `sha256sum`), 3) **Disponibilidad** (que el servidor esté accesible) y 4) **Exclusión de usuarios externos** (como hicimos con el Firewall)."*
5. **¿Qué es la Defensa en Profundidad?**
   - *"Es no depender de una sola barrera, sino combinar varias capas de seguridad independientes (Firewall de red + Autenticación con Hash/Salt + Permisos/ACL + Comprobador de integridad)."*
