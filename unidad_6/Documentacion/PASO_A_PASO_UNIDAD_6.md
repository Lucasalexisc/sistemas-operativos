# GUÍA PASO A PASO: EJECUCIÓN UNIDAD 6 EN RED HAT ENTERPRISE LINUX (RHEL)
## SEGURIDAD — DEMOSTRACIÓN UNIFICADA EN UN SOLO SCRIPT (`ejecutar_tpo.sh`)

En la carpeta `unidad_6` tenés **un único script directo (`ejecutar_tpo.sh`)** acompañado del script protegido (`pagos_empresa.sh`). Al ejecutarlo recorre en orden las **4 capas de seguridad**:

1. **Red y Firewall entre servidores (`servera` y `serverb`):**
   - Verifica la conectividad por red con `ping` a `servera` y `serverb`.
   - Configura el **Firewall (`firewall-cmd`)**: **bloquea** el puerto `8080/tcp` en `servera` y lo **abre** en `serverb`, probando con `curl` desde `workstation` que `servera` rechaza la conexión (`[BLOQUEADO]`) y `serverb` la permite (`[PERMITIDO]`).
2. **Autenticación con Hash + Salt en `/etc/shadow`:**
   - Crea el usuario autorizado `auditor` (`useradd -m`), le asigna contraseña (`chpasswd`) y muestra su línea real en `/etc/shadow` cifrada con Hash + Salt aleatorio.
3. **Permisos exclusivos con Lista de Control de Acceso (ACL):**
   - Cierra un archivo confidencial con `chmod 600` y utiliza `setfacl -m u:auditor:r--` y `getfacl` para darle permiso de lectura únicamente al usuario `auditor`.
4. **Comprobador de Integridad con Hash SHA-256 (`sha256sum`):**
   - Guarda la huella digital oficial de `pagos_empresa.sh` en `sumacomp.txt`.
   - Verifica la huella con `sha256sum -c`: cuando el archivo está sano permite ejecutarlo; luego simula que un **virus** le agrega una línea maliciosa, detecta que el Hash cambió y **bloquea la ejecución**. Finalmente restaura el archivo original y deja el entorno limpio.

---

## 1. Actualizar el Repositorio en Red Hat

```bash
cd ~/sistemas-operativos
git pull origin main
./preparar_todo.sh
cd unidad_6
```

---

## 2. Ejecutar la Demostración Completa

```bash
./ejecutar_tpo.sh
```
