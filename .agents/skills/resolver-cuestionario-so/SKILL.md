---
name: resolver-cuestionario-so
description: >-
  Resuelve los cuestionarios teóricos y preguntas de examen de las unidades de Sistemas Operativos (UADE / Red Hat), explicando cada concepto desde cero de manera simple, intuitiva y accesible para principiantes (con analogías cotidianas), asegurando al mismo tiempo la rigurosidad técnica necesaria para aprobar exámenes y defensas orales.
---

# Skill: Resolución Pedagógica de Cuestionarios de Sistemas Operativos

Esta skill define el método para responder y documentar cuestionarios oficiales de la materia **Sistemas Operativos (UADE)** de forma **didáctica, sencilla y accesible desde cero**, ideal para quienes no tienen conocimientos avanzados previos, pero asegurando los conceptos técnicos exactos que evalúan los profesores.

---

## 1. Principio Fundamental: "Explicar desde cero sin rodeos"

Al responder cada pregunta del cuestionario, el objetivo es que **cualquier persona que nunca cursó la materia pueda entenderlo en la primera lectura**.

### Las 3 Reglas de Oro de Explicación:
1. **Evitar lenguaje innecesariamente críptico:** Si se usa un término técnico obligatorio (como *MMU*, *TLB*, *Thrashing*, *Paginación*), se debe definir inmediatamente con una palabra sencilla o una analogía cotidiana.
2. **Uso de analogías visuales:** Emplear ejemplos del mundo real (un estacionamiento de autos, una biblioteca, cajones de ropa, un escritorio de trabajo, etc.) para fijar la intuición antes de la teoría formal.
3. **Contundencia en preguntas de afirmación (¿Es correcto...?):** Indicar en el primer renglón y en negrita: **VERDADERO** o **FALSO**, y fundamentar el "por qué" en lenguaje directo.

---

## 2. Estructura Estándar de Cada Respuesta

Cada una de las preguntas debe desarrollarse siguiendo este formato de 3 bloques:

```markdown
### Pregunta X: [Texto exacto de la pregunta]

> 💡 **En palabras simples (Para entenderlo de cero):**
> [Analogía cotidiana o explicación en criollo de 2 o 3 oraciones que resume la idea básica.]

**Explicación y Concepto de Cátedra:**
[Desarrollo claro del concepto según los apuntes de la unidad y autores de cátedra (Tanenbaum, Silberschatz, Stallings). Explicación paso a paso de qué pasa en la computadora, qué hace el hardware y qué hace el sistema operativo.]

📌 **Ejemplo Práctico / En Linux:**
[Un ejemplo real o en consola que permita aterrizar la idea a la práctica (comandos, scripts, comportamiento observable).]
```

---

## 3. Procedimiento para Resolver un Nuevo Cuestionario

Cuando el usuario solicite responder el cuestionario de una unidad (por ejemplo, Unidad 3, 4, 5 o 6):

1. **Lectura de Fuentes:**
   - Leer el archivo con las preguntas de la unidad (`Consignas y cuestionario (Unidad X).md` o `.pdf`).
   - Consultar el resumen teórico oficial de la materia (`Unidad X.pdf`).
2. **Desarrollo Exhaustivo:**
   - No omitir ninguna pregunta. Si el cuestionario tiene 44 preguntas, se responden las 44 una por una.
   - Mantener el orden y la numeración original para que el alumno pueda guiarse fácilmente durante el estudio.
3. **Generación del Archivo de Estudio:**
   - Guardar el resultado en un archivo Markdown independiente dentro de la carpeta correspondiente:
     `Unidad_X/CUESTIONARIO_RESUELTO_UNIDAD_X.md`.
   - Organizar las preguntas por módulos temáticos para facilitar repasos parciales antes del examen.

---

## 4. Checklist de Calidad Pedagógica

- [ ] ¿Un estudiante que no tiene idea del tema entiende la respuesta al leerla?
- [ ] ¿Se usaron analogías claras para los conceptos abstractos?
- [ ] ¿Las preguntas de Verdadero/Falso inician explícitamente con **VERDADERO** o **FALSO**?
- [ ] ¿Se preservaron los términos técnicos clave que busca el docente en una corrección?
- [ ] ¿Se respondieron todas las preguntas del cuestionario sin saltarse ninguna?
