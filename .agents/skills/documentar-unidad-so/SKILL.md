---
name: documentar-unidad-so
description: >-
  Guía y estandariza la elaboración de la documentación técnica, práctica y teórica para cada ejercicio y unidad del Trabajo Práctico Obligatorio (TPO) de Sistemas Operativos (UADE / Red Hat). Utiliza esta skill para generar o auditar documentos de entrega por unidad, garantizando el cumplimiento de las 17 consignas formales (problema hipotético, solución en consola Red Hat, marco teórico de cátedra, análisis de syscalls/scripts, capturas y preguntas de defensa oral).
---

# Skill: Documentación de Unidades para el TPO de Sistemas Operativos

Esta skill proporciona el procedimiento paso a paso, las pautas pedagógicas y la plantilla estandarizada para redactar la documentación oficial de cada uno de los 6 ejercicios del Trabajo Práctico Obligatorio (TPO) de la materia **Sistemas Operativos (UADE)**, con enfoque en la plataforma **Red Hat Enterprise Linux**.

---

## 1. Marco Normativo y Consignas del TPO

Toda documentación generada bajo esta skill debe alinearse estrictamente a las reglas del archivo `Consignas TPO.md`:

1. **Estructura Modular (6 Unidades = 6 Ejercicios):** Cada entrega/unidad aborda temas específicos de su respectiva unidad del programa y su correlato en el curso de Red Hat.
2. **Problema Hipotético Empresarial:** Cada ejercicio parte de una situación o incidente corporativo verosímil, claro y simple (consigna 8 y 13).
3. **Solución en Consola Red Hat:** La resolución se realiza mediante la línea de comandos (CLI) de Red Hat, con comandos reproducibles y placeholders para capturas de pantalla (consignas 9 y 10).
4. **Apartado Teórico Obligatorio:** Se debe incluir un marco conceptual sólido que cite los autores y textos de cátedra (Tanenbaum, Silberschatz, Stallings, Red Hat) vinculando la práctica con la teoría (consigna 11).
5. **Programación y Scripting:** Incorporar Shell Scripting (Bash) y/o código en C/C++ (especialmente valorado según consigna 15).
6. **Preparación para la Defensa Oral Individual:** Cualquier miembro del grupo puede ser seleccionado al azar para defender el ejercicio y responder preguntas teóricas de la unidad (consignas 5, 6 y 16). Por ello, el documento debe incluir un banco de preguntas y respuestas modelo.

---

## 2. Estructura Obligatoria de Cada Documento

Cada archivo de documentación debe crearse en su respectivo directorio (ejemplo: `Unidad 1/DOCUMENTACION_UNIDAD_1.md`) con las siguientes 7 secciones obligatorias:

### Sección 1: Portada y Ficha Técnica
- Asignatura, Institución, Cuatrimestre, Unidad abordada.
- Título del ejercicio y nombres de los integrantes del equipo.
- Tecnologías y herramientas utilizadas (Bash, C, Red Hat CLI, `strace`, `gdb`, `systemd`, etc.).

### Sección 2: Planteo del Problema Hipotético
- Contexto de la organización/empresa ficticia.
- Incidente o requerimiento técnico presentado.
- Comportamiento observable del sistema (mensajes de error ambiguos, cuellos de botella, condiciones de carrera, etc.).
- Objetivo técnico a resolver por el equipo de Sysadmins / DevOps.

### Sección 3: Fundamentos Teóricos de la Unidad
- Resumen conceptual riguroso extraído del PDF oficial de la unidad (`Unidad X.pdf`).
- Explicación de los mecanismos del Kernel de Linux involucrados:
  - Modo Núcleo (Ring 0) vs Modo Usuario (Ring 3).
  - Llamadas al sistema (Syscalls) y wrappers de `glibc`.
  - Descriptores de archivos, VFS, inodos, señales, memoria virtual o sincronización según corresponda a la unidad.
- Referencias bibliográficas formales.

### Sección 4: Arquitectura y Código de la Solución
- Código fuente completo con sintaxis resaltada (`bash`, `c`, `makefile`).
- Explicación detallada línea por línea o bloque por bloque.
- Justificación de directivas, flags, redirecciones y variables de entorno.

### Sección 5: Guía Práctica de Ejecución en Consola Red Hat
- Pasos ordenados y comandos exactos para clonar o preparar el entorno:
  - Creación de directorios (`mkdir`, `cd`).
  - Asignación de permisos de ejecución (`chmod +x`).
  - Compilación si aplica (`gcc -Wall -pthread ...`).
- Ejecución del script o binario.
- Output textual esperado tal cual se ve en la terminal.
- Espacios designados (`[INSERTAR CAPTURA DE PANTALLA: descripción]`) para adjuntar evidencia visual.

### Sección 6: Análisis Forense y Diagnóstico de Resultados
- Desglose técnico de las llamadas al sistema o señales interceptadas.
- Explicación de códigos de retorno (`0`, `-1`, constantes `errno` como `ENOENT`, `EACCES`, etc.).
- Demostración empírica de cómo la solución resuelve el problema planteado inicialmente.

### Sección 7: Banco de Preguntas y Respuestas para la Defensa Oral
- Mínimo de 5 a 6 preguntas conceptuales de alta exigencia que el docente evaluador podría realizar de forma individual.
- Respuestas modelo fundamentadas técnica y teóricamente, listas para ser estudiadas por cualquier integrante del grupo.

---

## 3. Checklist de Validación antes de dar por finalizada la Unidad

- [ ] ¿El problema hipotético es claro, creíble y creativo?
- [ ] ¿Se utiliza la consola de Red Hat y se detallan comandos exactos?
- [ ] ¿Se incluye el apartado teórico con citas de la bibliografía de la materia?
- [ ] ¿El código está explicado en profundidad (no solo a alto nivel)?
- [ ] ¿Están previstos los placeholders para capturas de pantalla?
- [ ] ¿Hay al menos 5 preguntas teóricas para la defensa individual con respuestas completas?
- [ ] ¿El archivo Markdown está guardado con nombres legibles y vínculos relativos correctos?

---

## 4. Recursos y Plantilla

Para acelerar la creación de nuevas unidades, utilizar como base la plantilla ubicada en:
[Plantilla de Documentación de Unidad](./resources/plantilla_unidad.md).
