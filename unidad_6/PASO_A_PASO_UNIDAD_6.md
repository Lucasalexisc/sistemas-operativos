# GUÍA PASO A PASO: EJECUCIÓN UNIDAD 6 EN RED HAT ENTERPRISE LINUX (RHEL)
## SEGURIDAD — COMPROBADOR DE INTEGRIDAD (`sumacomp` / `sha256sum`) Y PERMISOS ACL

Esta guía contiene los comandos para actualizar el repositorio desde GitHub y explicar el ejercicio de la Unidad 6 de forma súper simple (igual que el de la Unidad 1, usando dos scripts cortos en Bash).

---

## 1. Actualizar el Repositorio en Red Hat

```bash
cd ~/sistemas-operativos
git pull origin main
cd unidad_6
```

---

## 2. Ejecutar el Script en Red Hat

```bash
chmod +x ejecutar_tpo.sh pagos_empresa.sh
./ejecutar_tpo.sh
```

---

## 3. ¿Cómo funciona el ejercicio explicado súper simple?

Este ejercicio implementa exactamente el **"Comprobador de Integridad (`sumacomp`)"** que está en la **página 44 del PDF oficial de la Unidad 6**:

1. **El Programa de la Empresa (`pagos_empresa.sh`):**
   - Es un script de 4 líneas que simula hacer las transferencias bancarias de sueldos de la empresa.
2. **Paso 1 — Le sacamos su "Huella Digital" (`sha256sum`):**
   - Cuando sabemos que el programa está limpio, calculamos su **Hash SHA-256** (una función de una vía) y lo guardamos en el archivo `sumacomp.txt`.
3. **Paso 2 — Verificación antes de ejecutar (`sha256sum -c sumacomp.txt`):**
   - Antes de correr el programa, el script compara su huella actual contra `sumacomp.txt`. Como nadie lo tocó, dice **`pagos_empresa.sh: La suma coincide`** y lo ejecuta normalmente.
4. **Paso 3 y 4 — Un Virus modifica el archivo y el Comprobador lo bloquea:**
   - Simulamos que un **virus o intruso activo** le agrega una línea maliciosa adentro a `pagos_empresa.sh` (`echo "[VIRUS]: Robando contrasenas..." >> pagos_empresa.sh`).
   - Cuando nuestro script vuelve a verificar con `sha256sum -c sumacomp.txt`, como el archivo cambió aunque sea en una línea, **su huella digital cambió por completo**. Dice **`La suma no coincide`** y **cancela la ejecución del virus**.
5. **Paso 5 — Permisos y Lista de Control de Acceso (`ls -l` y `getfacl`):**
   - Muestra cómo está protegido el archivo en Linux para que otros usuarios no puedan tocarlo (`chmod 750` y `getfacl`).
