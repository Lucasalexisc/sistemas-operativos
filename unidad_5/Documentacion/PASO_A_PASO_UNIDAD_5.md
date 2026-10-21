# GUÍA PASO A PASO: EJECUCIÓN UNIDAD 5 EN RED HAT ENTERPRISE LINUX (RHEL)
## SUBSISTEMA DE E/S — SIN BÚFER VS. CON BÚFER (`sin_bufer.c` y `con_bufer.c`)

Esta guía contiene los comandos para actualizar el repositorio desde GitHub y explicar el ejercicio de la Unidad 5 de forma súper sencilla (igual que el de la Unidad 2).

---

## 1. Actualizar el Repositorio en Red Hat

```bash
cd ~/sistemas-operativos
git pull origin main
cd unidad_5
```

---

## 2. Ejecutar el Script en Red Hat

```bash
chmod +x ejecutar_tpo.sh
./ejecutar_tpo.sh
```

---

## 3. ¿Cómo funciona el ejercicio explicado súper simple?

1. **El Problema:**
   - Queremos escribir **100.000 letras `'A'`** en un archivo de texto.
   - Tenemos dos programas cortos en C (de 20 líneas cada uno, igual que `carrera.c` y `seguro.c` en la Unidad 2):
2. **`sin_bufer.c` (Modo Lento - Sin Búfer):**
   - Usa un `for` de 100.000 vueltas y adentro llama a `write(fd, "A", 1)` para escribir **1 sola letra por vez**.
   - **¿Por qué tarda mucho?** Porque cada vez que llamás a `write()`, tu programa frena y le pide permiso al **Kernel (Modo Núcleo)**. Hacer **100.000 viajes al Kernel** para llevar 1 letrita por viaje es lentísimo.
3. **`con_bufer.c` (Modo Rápido - Con Búfer):**
   - Crea un arreglo en memoria `char bufer[4000]` (un "carrito") con **4.000 letras `'A'`** adentro.
   - Usa un `for` de **solo 25 vueltas** (`25 x 4000 = 100.000 letras`) y llama a `write(fd, bufer, 4000)`.
   - **¿Por qué es instantáneo?** Porque en vez de hacer 100.000 viajes al Kernel, hace **solo 25 viajes**.
4. **La Prueba en Consola (`time` y `strace -c`):**
   - `time`: muestra que `sin_bufer` tarda muchísimo más que `con_bufer`.
   - `strace -c -e trace=write`: cuenta las llamadas reales al sistema y muestra **`100000 calls`** en `sin_bufer` contra **`25 calls`** en `con_bufer`.
