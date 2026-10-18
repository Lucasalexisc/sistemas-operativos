# GUÍA PASO A PASO: EJECUCIÓN UNIDAD 3 EN RED HAT ENTERPRISE LINUX (RHEL)
## ADMINISTRACIÓN DE MEMORIA — ASIGNACIÓN CONTIGUA, FRAGMENTACIÓN EXTERNA Y EVOLUCIÓN A PAGINACIÓN

Esta guía contiene los comandos exactos y explicaciones sencillas para sincronizar el repositorio desde GitHub (`Lucasalexisc/sistemas-operativos`) y ejecutar el ejercicio de la Unidad 3 en la consola de Red Hat.

---

## 1. Subir los archivos a GitHub (Desde tu PC donde estás editando)

Para asegurar que todo el contenido de la Unidad 3 esté actualizado en GitHub:

```bash
# 1. Pararse en la raíz del repositorio local
cd "c:\Users\lucas\OneDrive\Escritorio\UADE\2026\Segundo cuatrimestre\3. Sistemas operativos\Segundo parcial\TPO\sistemas-operativos"

# 2. Agregar los archivos de la unidad 3
git add unidad_3/

# 3. Guardar el commit
git commit -m "Entrega Unidad 3: Guia paso a paso, simulador de memoria en C y script orquestador"

# 4. Subir a GitHub
git push origin main
```

---

## 2. Traer el Repositorio en la Consola de Red Hat

Abrí la terminal de Red Hat Enterprise Linux y ejecutá según tu caso:

### Opción A: Si es la primera vez que vas a clonar el repo en Red Hat
```bash
# 1. Ir a tu carpeta personal (home)
cd ~

# 2. Clonar el repositorio desde GitHub
git clone https://github.com/Lucasalexisc/sistemas-operativos.git

# 3. Entrar a la carpeta de la Unidad 3
cd sistemas-operativos/unidad_3
```

### Opción B: Si ya tenías clonado el repositorio previamente en Red Hat
```bash
# 1. Entrar a la carpeta del repositorio
cd ~/sistemas-operativos

# 2. Descargar los últimos cambios subidos
git pull origin main

# 3. Entrar a la carpeta de la Unidad 3
cd unidad_3
```

---

## 3. Ejecutar el Script en Red Hat

Una vez dentro del directorio `unidad_3`:

```bash
# 1. Otorgar permisos de ejecución al script
chmod +x ejecutar_tpo.sh

# 2. Ejecutar el script
./ejecutar_tpo.sh
```

---

## 4. ¿Qué hace y qué muestra el programa en pantalla?

El script `ejecutar_tpo.sh` ejecuta automáticamente las siguientes 3 fases:

1. **Compilación en C con GCC:**  
   Compila `simulador_memoria.c` con `gcc simulador_memoria.c -o simulador_memoria`.
2. **Ejecución 1 (Modo `F` - Primer Ajuste / First-Fit):**  
   - Los procesos solicitan memoria contigua: $P_1$ ($212\text{ KB}$), $P_2$ ($417\text{ KB}$), $P_3$ ($112\text{ KB}$) y $P_4$ ($426\text{ KB}$).
   - First-Fit asigna el primer hueco que encuentra: mete a $P_1$ en el hueco 2 ($500\text{ KB}$) y a $P_2$ en el hueco 5 ($600\text{ KB}$).
   - Al llegar $P_4$ ($426\text{ KB}$), **es RECHAZADO**.
   - **Evidencia de Fragmentación Externa:** El sistema reporta **959 KB libres en total** dispersos en la RAM ($100$, $176$, $200$, $300$ y $183\text{ KB}$), pero ningún hueco individual alcanza los $426\text{ KB}$ continuos requeridos.
3. **Ejecución 2 (Modo `B` - Mejor Ajuste / Best-Fit):**  
   - Examina toda la lista y asigna el hueco más ajustado para cada proceso.
   - **Resultado:** Acomoda exitosamente al **100% de los procesos** (incluyendo $P_4$), preservando los huecos mayores para los procesos grandes.
4. **Comparativa de Tiempos con `time`:**  
   Mide la diferencia de ciclos de CPU entre la rapidez de First-Fit (corte temprano con `break`) y el recorrido completo que exige Best-Fit.

---

## 5. Resumen para la Defensa Oral Individual (1 a 2 Minutos)

Si el docente evaluador te selecciona individualmente para defender la Unidad 3, explicás estos 3 puntos clave:

1. **El Problema Hipotético (30 segundos):**  
   *"En nuestro servidor Red Hat simulamos un motor de base de datos en memoria que asigna bloques contiguos de RAM. Los usuarios experimentaban caídas porque el sistema rechazaba solicitudes de memoria informando espacio insuficiente, aun cuando las herramientas de monitoreo (`free -m` y `/proc/meminfo`) mostraban casi 1 MB libre (959 KB)."*
2. **La Demostración Práctica (45 segundos):**  
   *"Con el simulador en C demostramos empíricamente la causa raíz: bajo el algoritmo de Primer Ajuste (First-Fit), la memoria queda dividida en pequeños bloques aislados. El proceso $P_4$ de 426 KB no puede alojarse porque el hueco continuo más grande remanente mide solo 300 KB. Al cambiar a Mejor Ajuste (Best-Fit), el sistema asigna los 4 procesos con éxito al optimizar los huecos."*
3. **El Remate Teórico (Preguntas clave de cátedra):**  
   - **¿Qué es la fragmentación externa? (Pregunta 32):** Es cuando la memoria libre total disponible en el sistema es superior al tamaño requerido por un proceso, pero la solicitud no se puede satisfacer porque la memoria está fragmentada en bloques no contiguos dispersos.
   - **¿Cómo se soluciona en la teoría y en la práctica? (Preguntas 33 y 34):**
     - En teoría: Mediante **compactación** (mover físicamente los procesos en la RAM para juntar los huecos, pero consume muchísimo tiempo de CPU).
     - En los sistemas operativos modernos como Red Hat: Mediante **Paginación y Memoria Virtual**, dividiendo los programas en páginas y la memoria física en marcos (*frames*) de 4 KB, permitiendo que un proceso se almacene en marcos dispersos sin exigir contigüidad física.
