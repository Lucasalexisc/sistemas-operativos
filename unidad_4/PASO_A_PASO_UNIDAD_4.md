# GUÍA PASO A PASO: EJECUCIÓN UNIDAD 4 EN RED HAT ENTERPRISE LINUX (RHEL)
## SISTEMA DE ARCHIVOS — ASIGNACIÓN CONTIGUA VS. NODOS-I (INODES)

Esta guía contiene los comandos para sincronizar el repositorio desde GitHub (`Lucasalexisc/sistemas-operativos`) y explicar el ejercicio de la Unidad 4 de forma simple y directa.

---

## 1. Subir los archivos actuales a GitHub (Desde tu PC)

```bash
git add unidad_4/ unidad_5/ unidad_6/
git commit -m "Simplificacion de scripts y explicaciones de Unidad 4, 5 y 6"
git push origin main
```

---

## 2. Actualizar el Repositorio en la Consola de Red Hat

Abrí la terminal de Red Hat Enterprise Linux:

```bash
cd ~/sistemas-operativos
git pull origin main
cd unidad_4
```

---

## 3. Ejecutar el Script en Red Hat

```bash
chmod +x ejecutar_tpo.sh
./ejecutar_tpo.sh
```

---

## 4. ¿Cómo funciona el ejercicio explicado súper simple?

1. **El Problema (Igual que en la Unidad 3, pero llevado al Disco):**
   - Queremos guardar **4 archivos** en el disco (de `212`, `417`, `112` y `426` bloques).
   - Como se borraron archivos viejos antes, el espacio libre del disco quedó partido en **5 huecos separados** (`100`, `500`, `200`, `300` y `600` bloques = **1700 bloques libres en total**).
2. **Qué pasa con la Asignación Contigua (`./simulador_filesystem F`):**
   - La regla contigua exige que **todo el archivo entre de corrido en un solo hueco**.
   - Entran los primeros 3 archivos, pero cuando quiere entrar el **Archivo 4 (426 bloques)**, tira **`ERROR: NO ENTRA`**, ¡a pesar de que en el disco **sobran 959 bloques libres**! Eso es la **Fragmentación Externa en el disco**.
3. **Cómo lo soluciona Linux con Inodos (`./simulador_filesystem I`):**
   - Linux (`ext4`) no guarda los archivos todos juntos de corrido: usa un **Inodo** (una fichita índice con flechas).
   - El Inodo **parte el archivo en bloques y los reparte en cualquier hueco libre que encuentre**. Así se guardan los 4 archivos sin errores y sin tener que desfragmentar el disco.
4. **Comandos reales de Linux al final del script:**
   - `ls -li` y `stat`: muestran el **número de Inodo real** de nuestro archivo en Red Hat.
   - `file`: muestra cómo Linux sabe qué tipo de archivo es leyendo su **Número Mágico** (sus primeros bytes) y no su extensión.
