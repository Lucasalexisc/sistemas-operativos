# GUÍA PASO A PASO: EJECUCIÓN UNIDAD 6 EN RED HAT ENTERPRISE LINUX (RHEL)
## SEGURIDAD — 2 OPCIONES LISTAS PARA MOSTRAR AL PROFESOR

En la carpeta `unidad_6` tenés **las 2 opciones listas** para mostrar la semana que viene en el laboratorio de Red Hat:

- **Opción 1 (`opcion1_servers_remotos.sh`):** Usa los servidores del laboratorio (`workstation`, `servera` y `serverb`):
  1. Verifica cómo se conectan por red (`ping` a `servera` y `serverb`).
  2. Configura el **Firewall (`firewall-cmd`)**: **bloquea** el puerto `8080/tcp` en `servera` y lo **abre** en `serverb`, probando desde `workstation` que `servera` rechaza la conexión y `serverb` la permite.
  3. Crea el usuario autorizado `auditor` (`useradd`), muestra su contraseña cifrada con **Hash + Salt en `/etc/shadow`** y le da permiso exclusivo a un archivo secreto usando **ACL (`setfacl` y `getfacl`)**.
- **Opción 2 (`opcion2_local_completo.sh`):** Funciona en **un solo servidor** (ideal si `servera` o `serverb` no están prendidos):
  1. Muestra los puertos abiertos (`ss -tuln`) y cómo abrir/bloquear el puerto `8080/tcp` en el Firewall local (`firewall-cmd`).
  2. Crea el usuario `auditor` y muestra su **Hash + Salt en `/etc/shadow`**.
  3. Le asigna permisos exclusivos con **ACL (`setfacl` / `getfacl`)**.
  4. Ejecuta además el **Comprobador de Integridad Anti-Virus (`sha256sum -c`)** sobre `pagos_empresa.sh`.

---

## 1. Actualizar el Repositorio en Red Hat

```bash
cd ~/sistemas-operativos
git pull origin main
./preparar_todo.sh
cd unidad_6
```

---

## 2. Cómo Ejecutar Cualquiera de las 2 Opciones

Podés correr el lanzador principal `./ejecutar_tpo.sh` (que te pregunta cuál de las 2 opciones querés mostrar):

```bash
./ejecutar_tpo.sh
```

O ejecutar directamente la opción que elijas con el profesor:

```bash
# Para mostrar la Opción 1 (con servera y serverb):
./opcion1_servers_remotos.sh

# Para mostrar la Opción 2 (todo en un mismo servidor):
./opcion2_local_completo.sh
```
